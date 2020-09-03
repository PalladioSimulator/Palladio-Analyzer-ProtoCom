package org.palladiosimulator.protocom.tech.rest

import org.palladiosimulator.pcm.core.entity.Entity
import org.palladiosimulator.protocom.lang.xml.IClasspath
import org.palladiosimulator.protocom.tech.ConceptMapping

class JaxRsClasspathFile <E extends Entity> extends ConceptMapping<E> implements IClasspath{
	
	new(E pcmEntity) {
		super(pcmEntity)
	}
	
	override classPathEntries() {
	}
	
	override filePath() {
	}
	
	override projectName() {
	}
	
}