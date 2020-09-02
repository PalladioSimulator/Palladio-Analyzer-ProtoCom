package org.palladiosimulator.protocom.tech.rest.system

import org.palladiosimulator.pcm.system.System
import org.palladiosimulator.protocom.tech.rest.JaxRsPomFile

class JaxRsPom extends JaxRsPomFile<System>{
	
	new(System pcmEntity) {
		super(pcmEntity)
	}
	
	override filePath() {
		"pom.xml"
	}
	
}