package org.palladiosimulator.protocom.workflow;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Level;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.palladiosimulator.analyzer.workflow.core.configurations.AbstractPCMLaunchConfigurationDelegate;
import org.palladiosimulator.analyzer.workflow.core.configurations.PCMWorkflowConfigurationBuilder;
import org.palladiosimulator.protocom.jobs.ProtoComCodeGenerationJob;

import de.uka.ipd.sdq.codegen.simucontroller.debug.IDebugListener;
import de.uka.ipd.sdq.codegen.simucontroller.debug.SimulationDebugListener;
import de.uka.ipd.sdq.workflow.BlackboardBasedWorkflow;
import de.uka.ipd.sdq.workflow.WorkflowExceptionHandler;
import de.uka.ipd.sdq.workflow.jobs.IJob;
import de.uka.ipd.sdq.workflow.launchconfig.core.configbuilder.AbstractWorkflowConfigurationBuilder;
import de.uka.ipd.sdq.workflow.logging.console.LoggerAppenderStruct;
import de.uka.ipd.sdq.workflow.mdsd.blackboard.MDSDBlackboard;
import de.uka.ipd.sdq.workflow.ui.UIBasedWorkflow;
import de.uka.ipd.sdq.workflow.ui.UIBasedWorkflowExceptionHandler;

/**
 * The class adapts defined functionality in the AbstractMDSDLaunchConfigurationDelegate for SimuCom
 * Framework.
 * 
 */
public class ProtoComCodegenWorkflowLauncher
        extends AbstractPCMLaunchConfigurationDelegate<ProtoComGenerationConfiguration> {

    @Override
    protected BlackboardBasedWorkflow<MDSDBlackboard> createWorkflow(
            final ProtoComGenerationConfiguration workflowConfiguration, final IProgressMonitor monitor,
            final ILaunch launch) throws CoreException {
        return new UIBasedWorkflow<>(this.createWorkflowJob(workflowConfiguration, launch), monitor,
                this.createExceptionHandler(workflowConfiguration.isInteractive()), this.createBlackboard());
    }

    @Override
    protected WorkflowExceptionHandler createExceptionHandler(boolean interactive) {
        return new UIBasedWorkflowExceptionHandler(!interactive);
    }

    /*
     * (non-Javadoc)
     * 
     * @seede.uka.ipd.sdq.codegen.runconfig.LaunchConfigurationDelegate#
     * creataAttributesGetMethods(org.eclipse.debug.core.ILaunchConfiguration)
     */
    @Override
    protected ProtoComGenerationConfiguration deriveConfiguration(ILaunchConfiguration configuration, String mode)
            throws CoreException {
        ProtoComGenerationConfiguration config = new ProtoComGenerationConfiguration();

        AbstractWorkflowConfigurationBuilder builder;
        builder = new PCMWorkflowConfigurationBuilder(configuration, mode);
        builder.fillConfiguration(config);

        builder = new ProtoComGenerationLaunchConfigurationBasedConfigBuilder(configuration, mode);
        builder.fillConfiguration(config);

        return config;
    }

    /*
     * (non-Javadoc)
     * 
     * @see de.uka.ipd.sdq.codegen.simucontroller.runconfig.AbstractMDSDLaunchConfigurationDelegate#
     * setupLogging(org.apache.log4j.Level)
     */
    @Override
    protected List<LoggerAppenderStruct> setupLogging(Level logLevel) throws CoreException {
        List<LoggerAppenderStruct> loggerList = new ArrayList<>(super.setupLogging(logLevel));
        loggerList.add(setupLogger("de.uka.ipd.sdq.codegen", logLevel,
                Level.DEBUG == logLevel ? DETAILED_LOG_PATTERN : SHORT_LOG_PATTERN));
        loggerList.add(setupLogger("de.uka.ipd.sdq.simucomframework", logLevel,
                Level.DEBUG == logLevel ? DETAILED_LOG_PATTERN : SHORT_LOG_PATTERN));
        loggerList.add(setupLogger("de.uka.ipd.sdq.workflow.mdsd.emf.qvtr", logLevel,
                Level.DEBUG == logLevel ? DETAILED_LOG_PATTERN : SHORT_LOG_PATTERN));
        loggerList.add(setupLogger("de.uka.ipd.sdq.statistics", logLevel,
                Level.DEBUG == logLevel ? DETAILED_LOG_PATTERN : SHORT_LOG_PATTERN));

        return loggerList;
    }

    /*
     * (non-Javadoc)
     * 
     * @seede.uka.ipd.sdq.codegen.runconfig.LaunchConfigurationDelegate# createRunCompositeJob
     * (de.uka.ipd.sdq.codegen.runconfig.AttributesGetMethods)
     */
    @Override
    protected IJob createWorkflowJob(ProtoComGenerationConfiguration config, final ILaunch launch)
            throws CoreException {
        IDebugListener listener = null;

        if (config.isDebug()) {
            listener = new SimulationDebugListener(launch);
        }
        return new ProtoComCodeGenerationJob(config, listener);
    }
}
