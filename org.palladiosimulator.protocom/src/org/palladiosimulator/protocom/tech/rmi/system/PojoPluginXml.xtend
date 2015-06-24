package org.palladiosimulator.protocom.tech.rmi.system

import org.palladiosimulator.protocom.tech.rmi.PojoPluginXmlFile
import de.uka.ipd.sdq.pcm.system.System

class PojoPluginXml extends PojoPluginXmlFile<System>{
	
	new(System pcmEntity) {
		super(pcmEntity)
	}
	
	override extensionPoint() {
		'''de.uka.ipd.sdq.simucomframework.controller'''
	}
	
	override actionDelegateClass() {
		'''main.SimuComControl'''
	}
	
	override actionDelegateId() {
		'''de.uka.ipd.sdq.codegen.simucominstance.actionDelegate'''
	}
	
	override filePath() {
		"plugin.xml"
	}
}