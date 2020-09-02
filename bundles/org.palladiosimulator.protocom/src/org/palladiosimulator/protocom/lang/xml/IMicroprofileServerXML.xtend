package org.palladiosimulator.protocom.lang.xml

import org.palladiosimulator.protocom.lang.ICompilationUnit

interface IMicroprofileServerXML extends ICompilationUnit{
	
	def String serverDescription()
	
	def String webApplicationLocation()
}