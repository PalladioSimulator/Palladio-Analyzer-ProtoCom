package org.palladiosimulator.protocom.tech.rest.system

import org.palladiosimulator.pcm.system.System
import org.palladiosimulator.protocom.tech.rest.JaxRsJvmOptionsFile

class JaxRsJvmOptions extends JaxRsJvmOptionsFile<System>{
	
	new(System pcmEntity) {
		super(pcmEntity)
	}
	
	override filePath() {
		"/src/main/liberty/config/jvm.options"
	}
	
}