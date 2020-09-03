package org.palladiosimulator.protocom.tech.rest

import org.palladiosimulator.pcm.core.entity.Entity
import org.palladiosimulator.protocom.lang.xml.IMicroprofileJvmOptions
import org.palladiosimulator.protocom.tech.ConceptMapping

class JaxRsJvmOptionsFile <E extends Entity> extends ConceptMapping<E> implements IMicroprofileJvmOptions{
	
	new(E pcmEntity) {
		super(pcmEntity)
	}
	
	override filePath() {
	}
	
	override projectName() {
	}
	
	override injectionInterfaces() {
		#['url=http://localhost:9080/']
	}
	
}