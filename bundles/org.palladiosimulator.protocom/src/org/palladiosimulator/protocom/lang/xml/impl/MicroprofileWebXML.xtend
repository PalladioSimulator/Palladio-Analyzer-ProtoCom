package org.palladiosimulator.protocom.lang.xml.impl

import org.palladiosimulator.protocom.lang.GeneratedFile
import org.palladiosimulator.protocom.lang.xml.IMicroprofileWebXML

class MicroprofileWebXML extends GeneratedFile<IMicroprofileWebXML> implements IMicroprofileWebXML{
	
	override generate() {
			'''
		«header»
		«body»
		'''
	}
	
	def header() {
		'''<?xml version="1.0" encoding="UTF-8"?>'''
	}
	
	def body() {
		'''<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    		xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
    		version="3.1">
		    <display-name>«displayName»</display-name>

    		<welcome-file-list>
        		<welcome-file>index.html</welcome-file>
    		</welcome-file-list>
		</web-app>'''
	}
	
	override displayName() {
		provider.displayName
	}
	
}