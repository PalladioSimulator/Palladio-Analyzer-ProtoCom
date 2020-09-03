package org.palladiosimulator.protocom.tech.rest

import org.palladiosimulator.protocom.tech.ConceptMapping
import org.palladiosimulator.protocom.lang.java.IMicroprofileClass
import org.palladiosimulator.protocom.lang.java.util.JavaNames
import org.palladiosimulator.pcm.core.entity.Entity

/**
 * Common super type for all provider creating Java classes. Defines default values
 * for all templates.
 * 
 * @author Thomas Zolynski
 */
abstract class JaxRsClass<E extends Entity> extends ConceptMapping<E> implements IMicroprofileClass {
	
	new(E pcmEntity) {
		super(pcmEntity)
	}
	
	override superClass() {
	}
	
	override constructors() {
		newLinkedList
	}
	
	override packageName() {
		JavaNames::implementationPackage(pcmEntity)
	}
	
	override compilationUnitName() {
		JavaNames::javaName(pcmEntity)
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
		JavaNames::getMicroprofileFileName(pcmEntity)
	}
	
	override projectName(){
		
	}
	
	override annotations() {
	}
	
}