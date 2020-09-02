package org.palladiosimulator.protocom.tech.rest

import org.palladiosimulator.pcm.core.entity.Entity
import org.palladiosimulator.protocom.lang.xml.IMicroprofileServerXML
import org.palladiosimulator.protocom.tech.ConceptMapping

class JaxRsServerXMLFile <E extends Entity> extends ConceptMapping<E> implements IMicroprofileServerXML{
	
	new(E pcmEntity) {
		super(pcmEntity)
	}
	
	override filePath() {
	}
	
	override projectName() {
	}
	
	override serverDescription() {
		"Openliberty Server"
	}
	
	override webApplicationLocation() {
		"webapplication"
	}
	
}