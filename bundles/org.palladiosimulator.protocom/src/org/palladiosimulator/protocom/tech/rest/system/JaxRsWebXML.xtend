package org.palladiosimulator.protocom.tech.rest.system

import org.palladiosimulator.pcm.system.System
import org.palladiosimulator.protocom.tech.rest.JaxRsWebXMLFile

class JaxRsWebXML extends JaxRsWebXMLFile<System>{
	
	new(System pcmEntity) {
		super(pcmEntity)
	}
	
	override filePath() {
		"/src/main/liberty/webapp/WEB-INF/web.xml"
	}
	
}