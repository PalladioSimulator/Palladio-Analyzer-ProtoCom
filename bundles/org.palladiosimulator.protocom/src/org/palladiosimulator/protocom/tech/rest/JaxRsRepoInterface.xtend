package org.palladiosimulator.protocom.tech.rest

import org.palladiosimulator.pcm.core.entity.Entity
import org.palladiosimulator.protocom.lang.java.IMicroprofileInterface
import org.palladiosimulator.protocom.lang.java.util.JavaNames
import org.palladiosimulator.protocom.tech.ConceptMapping

class JaxRsRepoInterface <E extends Entity> extends ConceptMapping<E> implements IMicroprofileInterface{
	
	new(E pcmEntity) {
		super(pcmEntity)
	}
	
	override packageName() {
		//JavaNames::implementationPackage(pcmEntity)
		//JavaNames::fqnJavaEEInterfacePackage(pcmEntity)
		"interfaces"
	}
	
	override compilationUnitName() {
		//JavaNames::javaName(pcmEntity)
		JavaNames::fqnJavaEEInterfaceName(pcmEntity)
	}
	
	override interfaces() {
		newLinkedList
	}
	
	override methods() {
		newLinkedList
	}
	
	override fields() {
		newLinkedList
	}
	
	override filePath() {
		//JavaNames::getFilePath(pcmEntity)
		JavaNames::fqnMicroprofileOperationInterfacePath(pcmEntity)
		//JavaNames::fqnJavaEEOperationInterfacePath(pcmEntity)
	}
	
	override projectName() {
		//JavaNames::fqnJavaEEOperationInterfaceProjectName(pcmEntity)
	}
	
	override jaxRsInterfaceAnnotation() {
		JavaNames::fqnMicroprofileAnnotation(pcmEntity)
	}
	
}