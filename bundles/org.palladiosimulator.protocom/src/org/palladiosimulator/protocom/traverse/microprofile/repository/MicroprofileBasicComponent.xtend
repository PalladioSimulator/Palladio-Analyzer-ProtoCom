package org.palladiosimulator.protocom.traverse.microprofile.repository

import org.palladiosimulator.protocom.lang.java.impl.JClass
import org.palladiosimulator.protocom.lang.java.impl.JInterface
import org.palladiosimulator.protocom.lang.java.impl.MicroprofileClass
import org.palladiosimulator.protocom.lang.java.impl.MicroprofileInterface
import org.palladiosimulator.protocom.tech.rest.repository.JaxRsBasicComponentClass
import org.palladiosimulator.protocom.tech.rest.repository.JaxRsComponentClassInterface
import org.palladiosimulator.protocom.tech.rmi.repository.PojoBasicComponentContextClass
import org.palladiosimulator.protocom.tech.rmi.repository.PojoBasicComponentContextInterface
import org.palladiosimulator.protocom.tech.rmi.repository.PojoBasicComponentPortClass
import org.palladiosimulator.protocom.traverse.framework.repository.XBasicComponent
import org.palladiosimulator.protocom.tech.rest.repository.JaxRsOperationInterface
import org.palladiosimulator.protocom.lang.java.impl.JeeInterface
import org.palladiosimulator.protocom.tech.iiop.repository.JavaEEIIOPOperationInterface

/**
 * A Basic Component translates into the following Java compilation units:
 * <ul>
 * 	<li> a class implementing the component's resource demands,
 * 	<li> an interface for the component class,
 * 	<li> a context class for assembly,
 * 	<li> an interface for the context class,
 *  <li> a class for each component's port.
 * </ul>
 * 
 * @author Thomas Zolynski
 */
class MicroprofileBasicComponent extends XBasicComponent {
	override generate() {

		// interface and class for the component.
		// Necessity of interface is debatable. For now it is included, because the original ProtoCom used it as well.
		//generatedFiles.add(injector.getInstance(typeof(MicroprofileInterface)).createFor(new JaxRsComponentClassInterface(entity))) 
		generatedFiles.add(injector.getInstance(typeof(MicroprofileClass)).createFor(new JaxRsBasicComponentClass(entity)))

		entity.providedRoles_InterfaceProvidingEntity.forEach[
			generatedFiles.add(injector.getInstance(typeof(MicroprofileInterface)).createFor(new JaxRsOperationInterface(it)))
		]
		
		// interface and class for the context.
		//generatedFiles.add(injector.getInstance(typeof(JClass)).createFor(new PojoBasicComponentContextClass(entity)))
		//generatedFiles.add(
		//	injector.getInstance(typeof(JInterface)).createFor(new PojoBasicComponentContextInterface(entity)))

		// Ports. TODO? This iterator could be replaced by traversing in the XBasicComponent class.
		//entity.providedRoles_InterfaceProvidingEntity.forEach[
		//	generatedFiles.add(injector.getInstance(typeof(JClass)).createFor(new PojoBasicComponentPortClass(it)))
		//]
		

	}
}
