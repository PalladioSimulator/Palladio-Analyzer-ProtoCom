package org.palladiosimulator.protocom.traverse.microprofile.repository

import org.palladiosimulator.protocom.lang.java.impl.MicroprofileInterface
import org.palladiosimulator.protocom.tech.rest.repository.JaxRsOperationInterface
import org.palladiosimulator.protocom.traverse.framework.repository.XOperationInterface

/**
 * An Operation Interface translates into the following Java compilation units:
 * <ul>
 * 	<li> an interface.
 * </ul>
 * 
 * @author Thomas Zolynski
 */
class MicroprofileOperationInterface extends XOperationInterface {
	
	override generate() {

		//generatedFiles.add(injector.getInstance(typeof(MicroprofileInterface)).createFor(new JaxRsOperationInterface(entity)))

	}
}
