package org.palladiosimulator.protocom.lang.java.impl

import org.palladiosimulator.protocom.lang.java.IJMethod
import org.palladiosimulator.protocom.lang.java.IMicroprofileInterface

class MicroprofileInterface extends JCompilationUnit<IMicroprofileInterface> implements IMicroprofileInterface{
	
	override header() {
		'''
		package «packageName»;
		
		import javax.inject.Inject;
		import javax.ws.rs.Consumes;
		import javax.ws.rs.POST;
		import javax.ws.rs.Path;
		import javax.ws.rs.Produces;
		import javax.ws.rs.core.MediaType;
		import org.eclipse.microprofile.rest.client.annotation.RegisterProvider;
		import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;
		
		@RegisterRestClient
		@RegisterProvider(UnkownUrlExceptionMapper.class)
		@Path("«jaxRsInterfaceAnnotation»")
		public interface «compilationUnitName» «implementedClasses»
		'''
	}
	
	override body() {
		'''
		«FOR method : methods»
			«signature(method)»
		«ENDFOR»
		'''
	}
	
	def signature (IJMethod method) {
		'''
		
		@POST
		@Consumes(MediaType.APPLICATION_JSON)
		@Path("«method.name»")
		@Produces(MediaType.APPLICATION_JSON)
		«method.visibilityModifier» «method.returnType» «method.name» («method.parameters»)«IF method.throwsType != null» throws «method.throwsType»«ENDIF»;
		'''
	}
	
	override implementedClasses() {
		'''
		«IF interfaces != null»
			«FOR implInterface : interfaces BEFORE ' extends ' SEPARATOR ', '»«implInterface»«ENDFOR»
		«ENDIF»
		'''
	}
	
    override jaxRsInterfaceAnnotation() {
        provider.jaxRsInterfaceAnnotation;
    }
	
}