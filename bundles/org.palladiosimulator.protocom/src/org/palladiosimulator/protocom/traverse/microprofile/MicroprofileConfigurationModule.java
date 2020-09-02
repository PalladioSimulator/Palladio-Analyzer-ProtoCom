package org.palladiosimulator.protocom.traverse.microprofile;

import org.palladiosimulator.protocom.traverse.framework.CommonConfigurationModule;
import org.palladiosimulator.protocom.traverse.framework.allocation.XAllocation;
import org.palladiosimulator.protocom.traverse.framework.repository.XBasicComponent;
import org.palladiosimulator.protocom.traverse.framework.repository.XCompositeComponent;
import org.palladiosimulator.protocom.traverse.framework.repository.XInfrastructureInterface;
import org.palladiosimulator.protocom.traverse.framework.repository.XOperationInterface;
import org.palladiosimulator.protocom.traverse.framework.resourceenvironment.XResourceEnvironment;
import org.palladiosimulator.protocom.traverse.framework.system.XSystem;
import org.palladiosimulator.protocom.traverse.framework.usage.XUsageScenario;
import org.palladiosimulator.protocom.traverse.microprofile.allocation.MicroprofileAllocation;
import org.palladiosimulator.protocom.traverse.microprofile.repository.MicroprofileBasicComponent;
import org.palladiosimulator.protocom.traverse.microprofile.repository.MicroprofileCompositeComponent;
import org.palladiosimulator.protocom.traverse.microprofile.repository.MicroprofileInfrastructureInterface;
import org.palladiosimulator.protocom.traverse.microprofile.repository.MicroprofileOperationInterface;
import org.palladiosimulator.protocom.traverse.microprofile.resourceenvironment.MicroprofileResourceEnvironment;
import org.palladiosimulator.protocom.traverse.microprofile.system.MicroprofileSystem;
import org.palladiosimulator.protocom.traverse.microprofile.usage.MicroprofileUsageScenario;

/**
 * Google Guice binding for Java Standard Edition Protocom. This class is not using Xtend as its
 * superclass it not working properly with it.
 * 
 * @author Thomas Zolynski
 */
public class MicroprofileConfigurationModule extends CommonConfigurationModule {

    @Override
    protected void configure() {
        super.configure();

        bind(XBasicComponent.class).to(MicroprofileBasicComponent.class);
       // bind(XCompositeComponent.class).to(MicroprofileCompositeComponent.class);
        // bind(XOperationInterface.class).to(MicroprofileOperationInterface.class);
      //  bind(XInfrastructureInterface.class).to(MicroprofileInfrastructureInterface.class);
        bind(XSystem.class).to(MicroprofileSystem.class);
    //    bind(XAllocation.class).to(MicroprofileAllocation.class);
    //    bind(XResourceEnvironment.class).to(MicroprofileResourceEnvironment.class);
    //    bind(XUsageScenario.class).to(MicroprofileUsageScenario.class);
    }
}
