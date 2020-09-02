package org.palladiosimulator.protocom.tech.rest.repository

import org.palladiosimulator.pcm.repository.InfrastructureProvidedRole
import org.palladiosimulator.pcm.repository.OperationProvidedRole
import org.palladiosimulator.pcm.repository.ProvidedRole
import org.palladiosimulator.protocom.lang.java.impl.JMethod
import org.palladiosimulator.protocom.lang.java.util.JavaNames
import org.palladiosimulator.protocom.lang.java.util.PcmCommons
import org.palladiosimulator.protocom.tech.rest.JaxRsRepoInterface

/**
 * Defining the content of OperationInterface classes.
 * 
 * @author Thomas Zolynski, Sebastian Lehrig
 */
 
 class JaxRsOperationInterface extends JaxRsRepoInterface<ProvidedRole> {
	
	new(ProvidedRole entity) {
		super(entity)
	}
	
	override methods() {
		providedRoleMethods(pcmEntity)
	}
	
	def dispatch providedRoleMethods(OperationProvidedRole role) {
		role.providedInterface__OperationProvidedRole.signatures__OperationInterface.map[
			new JMethod()
				.withName(JavaNames::javaSignature(it))
				.withReturnType(PcmCommons::stackframeType)
				.withParameters(PcmCommons::stackContextParameterList)
		]
	}
	
	def dispatch providedRoleMethods(InfrastructureProvidedRole role) {
		role.providedInterface__InfrastructureProvidedRole.infrastructureSignatures__InfrastructureInterface.map[	
			new JMethod()
				.withName(JavaNames::javaSignature(it))
				.withReturnType(PcmCommons::stackframeType)
				.withParameters(PcmCommons::stackContextParameterList)
				.withImplementation("return null;")
		] 
	}
	
	/*override jaxRsInterfaceAnnotation() {
		JavaNames::javaName(pcmEntity)
	}*/
	
}
 
 /*
class JaxRsOperationInterface extends JaxRsInterface<OperationInterface> {
	
	new(OperationInterface entity) {
		super(entity)
	}
	
	override interfaces() {
		//#[ JavaConstants::RMI_REMOTE_INTERFACE ]
	}
	
	override methods() {
		pcmEntity.signatures__OperationInterface.map[
			new JMethod()
				.withName(JavaNames::javaSignature(it))
				.withReturnType(PcmCommons::stackframeType)
				.withParameters(PcmCommons::stackContextParameterList)
				//.withThrows(JavaConstants::RMI_REMOTE_EXCEPTION)
		]
	}
	
	override jaxRsInterfaceAnnotation() {
		JavaNames::javaName(pcmEntity)
	}
	
}*/