package org.palladiosimulator.protocom.tech.rest.system

import org.palladiosimulator.pcm.system.System
import org.eclipse.pde.internal.core.PDECore
import org.palladiosimulator.protocom.tech.rmi.PojoClasspathFile

class JaxRsClasspath extends PojoClasspathFile<System>{
	
	new(System pcmEntity) {
		super(pcmEntity)
	}
	
	override classPathEntries() {
		'''
	<classpathentry kind="con" path="«PDECore.JRE_CONTAINER_PATH»"/>
	<classpathentry kind="con" path="«PDECore.REQUIRED_PLUGINS_CONTAINER_PATH»"/>
	<classpathentry kind="src" path="src"/>
	<classpathentry kind="output" path="bin"/>'''
	}
	
	override filePath() {
		".classpath"
	}
	
}