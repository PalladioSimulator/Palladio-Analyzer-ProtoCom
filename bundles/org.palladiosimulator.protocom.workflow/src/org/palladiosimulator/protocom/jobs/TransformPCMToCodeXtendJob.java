package org.palladiosimulator.protocom.jobs;

import java.util.HashMap;

import org.eclipse.core.runtime.IProgressMonitor;
import org.palladiosimulator.protocom.ProtoComProject;
import org.palladiosimulator.protocom.ProtoComProjectFactory;
import org.palladiosimulator.protocom.traverse.framework.CommonConfigurationModule;
import org.palladiosimulator.protocom.traverse.framework.allocation.XAllocation;
import org.palladiosimulator.protocom.traverse.framework.repository.XRepository;
import org.palladiosimulator.protocom.traverse.framework.resourceenvironment.XResourceEnvironment;
import org.palladiosimulator.protocom.traverse.framework.system.XSystem;
import org.palladiosimulator.protocom.traverse.framework.usage.XUsageScenario;
import org.palladiosimulator.protocom.traverse.jee.JeeConfigurationModule;
import org.palladiosimulator.protocom.traverse.jeeservlet.JeeServletConfigurationModule;
import org.palladiosimulator.protocom.traverse.jse.JseConfigurationModule;
import org.palladiosimulator.protocom.traverse.jsestub.JseStubConfigurationModule;
import org.palladiosimulator.protocom.workflow.ProtoComGenerationConfiguration;

import com.google.inject.Guice;
import com.google.inject.Injector;

import org.palladiosimulator.analyzer.workflow.core.blackboard.PCMResourceSetPartition;
import org.palladiosimulator.analyzer.workflow.core.configurations.AbstractCodeGenerationWorkflowRunConfiguration;
import org.palladiosimulator.analyzer.workflow.core.jobs.LoadPCMModelsIntoBlackboardJob;
import org.palladiosimulator.pcm.repository.Repository;
import org.palladiosimulator.pcm.usagemodel.UsageScenario;
import de.uka.ipd.sdq.workflow.jobs.CleanupFailedException;
import de.uka.ipd.sdq.workflow.jobs.IBlackboardInteractingJob;
import de.uka.ipd.sdq.workflow.jobs.IJob;
import de.uka.ipd.sdq.workflow.jobs.JobFailedException;
import de.uka.ipd.sdq.workflow.jobs.SequentialBlackboardInteractingJob;
import de.uka.ipd.sdq.workflow.jobs.UserCanceledException;
import de.uka.ipd.sdq.workflow.mdsd.blackboard.MDSDBlackboard;

public class TransformPCMToCodeXtendJob extends SequentialBlackboardInteractingJob<MDSDBlackboard> implements IJob,
        IBlackboardInteractingJob<MDSDBlackboard> {

    protected ProtoComGenerationConfiguration configuration;

    public TransformPCMToCodeXtendJob(ProtoComGenerationConfiguration configuration) {
        this.configuration = configuration;
    }

    @Override
    public void execute(IProgressMonitor monitor) throws JobFailedException, UserCanceledException {
        // prepare project factory
        ProtoComProjectFactory.setProjectType(configuration.getCodeGenerationAdvice());

        // guice configuration
        CommonConfigurationModule guiceConfiguration = null;
        if (configuration.getCodeGenerationAdvice() == AbstractCodeGenerationWorkflowRunConfiguration.CodeGenerationAdvice.PROTO) {
            guiceConfiguration = new JseConfigurationModule();
        } else if (configuration.getCodeGenerationAdvice() == AbstractCodeGenerationWorkflowRunConfiguration.CodeGenerationAdvice.POJO) {
            guiceConfiguration = new JseStubConfigurationModule();
        } else if (configuration.getCodeGenerationAdvice() == AbstractCodeGenerationWorkflowRunConfiguration.CodeGenerationAdvice.EJB3) {
            guiceConfiguration = new JeeConfigurationModule();
        } else if (configuration.getCodeGenerationAdvice() == AbstractCodeGenerationWorkflowRunConfiguration.CodeGenerationAdvice.SERVLET) {
        	guiceConfiguration = new JeeServletConfigurationModule();
        }
        
        guiceConfiguration.setProjectURI(configuration.getStoragePluginID());
        Injector injector = Guice.createInjector(guiceConfiguration);

        // Repository
        for (int repositoryIndex = 0; repositoryIndex < getRepositoryCount(); repositoryIndex++) {
            getRepositoryTransformationSlots(repositoryIndex);
        }

        PCMResourceSetPartition pcmPartition = (PCMResourceSetPartition) this.myBlackboard
                .getPartition(LoadPCMModelsIntoBlackboardJob.PCM_MODELS_PARTITION_ID);

        for (Repository content : pcmPartition.getRepositories()) {
            injector.getInstance(XRepository.class).setEntity(content).transform();
        }

        // System
        injector.getInstance(XSystem.class).setEntity(pcmPartition.getSystem()).transform();

        // Allocation
        injector.getInstance(XAllocation.class).setEntity(pcmPartition.getAllocation()).transform();

        // Resource Environment
        injector.getInstance(XResourceEnvironment.class).setEntity(pcmPartition.getResourceEnvironment()).transform();

        // Usage
        for (UsageScenario scenario : pcmPartition.getUsageModel().getUsageScenario_UsageModel()) {
            injector.getInstance(XUsageScenario.class).setEntity(scenario).transform();
        }

        // compile
        for (ProtoComProject p : ProtoComProjectFactory.getCreatedProjects().values()) {
            p.compile();
        }
    }

    @Override
    public void cleanup(IProgressMonitor monitor) throws CleanupFailedException {
        ProtoComProjectFactory.cleanup();
    }

    @Override
    public String getName() {
        return "Generate ProtoCom Plugin Code";
    }

    private int getRepositoryCount() {
        PCMResourceSetPartition pcmPartition = (PCMResourceSetPartition) this.myBlackboard
                .getPartition(LoadPCMModelsIntoBlackboardJob.PCM_MODELS_PARTITION_ID);
        return pcmPartition.getRepositories().size();
    }

    /**
     * @return Creates a HashMap with all slots required for the transformation of
     *         {@link Repository}.
     */
    private HashMap<String, Object> getRepositoryTransformationSlots(int repositoryIndex) {
        HashMap<String, Object> sC2 = new HashMap<String, Object>();
        PCMResourceSetPartition pcmPartition = (PCMResourceSetPartition) this.myBlackboard
                .getPartition(LoadPCMModelsIntoBlackboardJob.PCM_MODELS_PARTITION_ID);
        sC2.put("pcmmodel", pcmPartition.getRepositories().get(repositoryIndex));
        return sC2;
    }

}
