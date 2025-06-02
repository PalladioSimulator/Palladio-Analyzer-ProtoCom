package org.palladiosimulator.protocom.jobs;

import org.eclipse.core.runtime.CoreException;
import org.palladiosimulator.analyzer.workflow.core.jobs.LoadPCMModelsIntoBlackboardJob;
import org.palladiosimulator.analyzer.workflow.jobs.ValidatePCMModelsJob;
import org.palladiosimulator.protocom.workflow.ProtoComGenerationConfiguration;

import de.uka.ipd.sdq.codegen.simucontroller.core.debug.IDebugListener;
import de.uka.ipd.sdq.workflow.jobs.IBlackboardInteractingJob;
import de.uka.ipd.sdq.workflow.jobs.SequentialBlackboardInteractingJob;
import de.uka.ipd.sdq.workflow.mdsd.blackboard.MDSDBlackboard;

/**
 * Main job for the SDQ workflow engine which will run a ProtoCom generation
 * 
 * @author Steffen Becker, Thomas Zolynski, Sebastian Lehrig
 */
public class ProtoComCodeGenerationJob extends SequentialBlackboardInteractingJob<MDSDBlackboard> implements
        IBlackboardInteractingJob<MDSDBlackboard> {

    public ProtoComCodeGenerationJob(final ProtoComGenerationConfiguration configuration) throws CoreException {
        this(configuration, null);
    }

    public ProtoComCodeGenerationJob(final ProtoComGenerationConfiguration configuration, final IDebugListener listener)
            throws CoreException {
        super(false);

        if (listener == null && configuration.isDebug()) {
            throw new IllegalArgumentException("Debug listener has to be non-null for debug runs");
        }

        // 1. Load PCM models into memory
        this.addJob(new LoadPCMModelsIntoBlackboardJob(configuration));

        // 2. Validate PCM models in memory
        this.addJob(new ValidatePCMModelsJob(configuration));

        // 3. Generate code into projects using Xtend
        this.addJob(new TransformPCMToCodeXtendJob(configuration));
    }
}