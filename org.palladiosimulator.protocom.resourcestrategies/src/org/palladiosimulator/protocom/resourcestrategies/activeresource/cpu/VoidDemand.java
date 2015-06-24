package org.palladiosimulator.protocom.resourcestrategies.activeresource.cpu;

import org.palladiosimulator.protocom.resourcestrategies.activeresource.AbstractDemandStrategy;
import org.palladiosimulator.protocom.resourcestrategies.activeresource.ResourceTypeEnum;

public class VoidDemand extends AbstractDemandStrategy {

    public VoidDemand() {
        super(0, 0, 0, 0, 0);
    }

    @Override
    public void run(long initial) {

    }

    public void initialiseStrategy(int degreeOfAccuracy) {
    }

    public void consume(double demand, double processingRate) {
    }

    @Override
    public ResourceTypeEnum getStrategysResource() {
        return ResourceTypeEnum.CPU;
    }

    @Override
    public String getName() {
        return "None";
    }

    @Override
    public void cleanup() {
        // Do nothing.
    }

}
