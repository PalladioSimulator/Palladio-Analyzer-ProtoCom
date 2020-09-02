package org.palladiosimulator.protocom.tech.rest

import org.palladiosimulator.pcm.core.entity.Entity
import org.palladiosimulator.protocom.lang.xml.IMicroprofileWebXML
import org.palladiosimulator.protocom.tech.ConceptMapping

class JaxRsWebXMLFile <E extends Entity> extends ConceptMapping<E> implements IMicroprofileWebXML{
	
	new(E pcmEntity) {
		super(pcmEntity)
	}
	
	override filePath() {
	}
	
	override projectName() {
	}
	
	override displayName() {
		"Liberty Project"
	}
	
}