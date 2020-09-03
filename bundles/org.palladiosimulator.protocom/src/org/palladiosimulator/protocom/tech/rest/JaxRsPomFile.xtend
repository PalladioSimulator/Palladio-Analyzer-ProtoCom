package org.palladiosimulator.protocom.tech.rest

import org.palladiosimulator.pcm.core.entity.Entity
import org.palladiosimulator.protocom.tech.ConceptMapping
import org.palladiosimulator.protocom.lang.xml.IMicroprofilePom

class JaxRsPomFile <E extends Entity> extends ConceptMapping<E> implements IMicroprofilePom{
	
	new(E pcmEntity) {
		super(pcmEntity)
	}
	
	override filePath() {
	}
	
	override projectName() {
	}
	
	override artifactName() {
		"artifactId"
	}
	
	override groupID() {
		"groupId"
	}
	
}