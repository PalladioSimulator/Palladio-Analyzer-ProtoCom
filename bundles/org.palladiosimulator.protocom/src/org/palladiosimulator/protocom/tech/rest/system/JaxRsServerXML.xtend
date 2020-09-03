package org.palladiosimulator.protocom.tech.rest.system

import org.palladiosimulator.pcm.system.System
import org.palladiosimulator.protocom.tech.rest.JaxRsServerXMLFile

class JaxRsServerXML extends JaxRsServerXMLFile<System>{
	
	new(System pcmEntity) {
		super(pcmEntity)
	}
	
	override filePath() {
		"/src/main/liberty/config/server.xml"
	}
	
}