package org.palladiosimulator.protocom.lang.xml

import org.palladiosimulator.protocom.lang.ICompilationUnit

interface IMicroprofilePom extends ICompilationUnit{
	
	def String artifactName()
	
	def String groupID()
}