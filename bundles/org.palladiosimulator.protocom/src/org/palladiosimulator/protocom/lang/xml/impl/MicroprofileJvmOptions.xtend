package org.palladiosimulator.protocom.lang.xml.impl

import org.palladiosimulator.protocom.lang.GeneratedFile
import org.palladiosimulator.protocom.lang.xml.IMicroprofileJvmOptions

class MicroprofileJvmOptions extends GeneratedFile<IMicroprofileJvmOptions> implements IMicroprofileJvmOptions{
	
	override generate() {
			'''
		«header»
		«body»
		'''
	}
	
	def header() {
		''' '''
	}
	
	def body() {
		'''
		«FOR interfaceLine : injectionInterfaces»
			-d«interfaceLine»
		«ENDFOR»
		
		'''
	}
	
	
	override injectionInterfaces() {
		provider.injectionInterfaces
	}
	
}