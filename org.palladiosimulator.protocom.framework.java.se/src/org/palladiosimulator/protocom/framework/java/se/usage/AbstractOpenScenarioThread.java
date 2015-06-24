package org.palladiosimulator.protocom.framework.java.se.usage;

import org.palladiosimulator.protocom.framework.java.se.utils.RunProperties;

import de.uka.ipd.sdq.sensorframework.entities.Experiment;
import de.uka.ipd.sdq.sensorframework.entities.ExperimentRun;
import de.uka.ipd.sdq.simucomframework.variables.StackContext;

/**
 * Abstract class for running open workload users.
 * 
 * Only one instance of this class represents the usage scenario and spawns a new thread each time
 * the interarrival time has passed.
 * 
 * @author Steffen, martens
 * 
 */
public abstract class AbstractOpenScenarioThread extends AbstractScenarioThread {

    private final RunProperties runProps;
    private final String interarrivalTime;

    public AbstractOpenScenarioThread(Experiment exp, ExperimentRun expRun, String scenarioName,
            RunProperties runProps, String interarrivalTimeInSec) {
        super(exp, expRun, scenarioName, runProps);
        this.runProps = runProps;
        this.interarrivalTime = interarrivalTimeInSec;

    }

    @Override
    protected void runAndMeasureUsageScenarioIteration() {

        new Thread() {
            @Override
            public void run() {
                if (LOGGER.isDebugEnabled()) {
                    LOGGER.debug("New Thread: Open Scenario (" + scenarioName + "), interarrival time: "
                            + interarrivalTime);
                    LOGGER.debug("Starting my scenario");
                }

                long start = System.nanoTime();
                getScenarioRunner(runProps).run();
                takeScenarioMeasurement(start);

                LOGGER.debug("Finished my scenario");
            }
        }.start();

        try {

            Double interarrivalTime = StackContext.evaluateStatic(this.interarrivalTime, Double.class) * 1000.0;
            Thread.sleep(interarrivalTime.longValue());

        } catch (InterruptedException e) {
            e.printStackTrace();
        }

    }

}
