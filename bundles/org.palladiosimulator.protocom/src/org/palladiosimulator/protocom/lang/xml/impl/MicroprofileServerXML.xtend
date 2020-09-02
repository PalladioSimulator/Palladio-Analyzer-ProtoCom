package org.palladiosimulator.protocom.lang.xml.impl

import org.palladiosimulator.protocom.lang.GeneratedFile
import org.palladiosimulator.protocom.lang.xml.IMicroprofileServerXML

class MicroprofileServerXML extends GeneratedFile<IMicroprofileServerXML> implements IMicroprofileServerXML{
	
	override generate() {
			'''
		«header»
		«body»
		'''
	}
	
	def header() {
		'''<server description="«serverDescription»">'''
	}
	
	def body() {
		'''<featureManager>
		    <feature>jaxrs-2.1</feature>
		    <feature>jsonp-1.1</feature>
		    <feature>cdi-2.0</feature>
		    <feature>mpConfig-1.4</feature>
		    <feature>mpRestClient-1.4</feature>
		    <feature>mpOpenAPI-1.1</feature>
		  </featureManager>
		
		  <variable name="default.http.port" defaultValue="9080"/>
		  <variable name="default.https.port" defaultValue="9443"/>
		
		  <httpEndpoint httpPort="${default.http.port}" httpsPort="${default.https.port}"
		      id="defaultHttpEndpoint" host="*" />

		  <webApplication location="«webApplicationLocation».war" contextRoot="/" />
		
		</server>'''
	}
	
	override serverDescription() {
		provider.serverDescription
	}
	
	override webApplicationLocation() {
		provider.webApplicationLocation
	}
	
}