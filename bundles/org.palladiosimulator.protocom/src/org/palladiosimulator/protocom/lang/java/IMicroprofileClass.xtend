package org.palladiosimulator.protocom.lang.java

import java.util.Collection

interface IMicroprofileClass extends IJClass{
	
	def String jaxRsClassPathAnnotation()
	
	def String jaxRsClassDependencyInjectionAnnotation()
	
	def Collection<? extends IJField> jaxRsClassDependencyInjection()
}