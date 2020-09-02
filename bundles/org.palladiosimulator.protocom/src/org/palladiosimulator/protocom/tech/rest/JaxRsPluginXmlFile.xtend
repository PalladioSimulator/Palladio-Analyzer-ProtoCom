package org.palladiosimulator.protocom.tech.rest

import org.palladiosimulator.pcm.core.entity.Entity
import org.palladiosimulator.protocom.lang.xml.IPluginXml
import org.palladiosimulator.protocom.tech.ConceptMapping

class JaxRsPluginXmlFile <E extends Entity> extends ConceptMapping<E> implements IPluginXml{
	
	new(E pcmEntity) {
		super(pcmEntity)
	}
	
	override extensionPoint() {
	}
	
	override actionDelegateClass() {
	}
	
	override actionDelegateId() {
	}
	
	override filePath() {
	}
	
	override projectName() {
	}
	
}