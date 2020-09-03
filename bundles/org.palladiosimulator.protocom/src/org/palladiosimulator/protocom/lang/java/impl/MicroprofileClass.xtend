package org.palladiosimulator.protocom.lang.java.impl

import java.util.Collection
import org.palladiosimulator.protocom.lang.java.IJField
import org.palladiosimulator.protocom.lang.java.IJMethod
import org.palladiosimulator.protocom.lang.java.IMicroprofileClass

class MicroprofileClass extends JCompilationUnit<IMicroprofileClass> implements IMicroprofileClass {
	
	
	override superClass() {
		provider.superClass
	}
	
	override constructors() {
		provider.constructors
	}
	
	override annotations() {
		provider.annotations
	}
	
	override Collection<String> interfaces() {
		provider.interfaces
	}
	
	override packageName() {
		provider.packageName
	}
	
	override header() {
			'''
			package «packageName»;
			
			import javax.enterprise.context.RequestScoped;
			import javax.inject.Inject;
			import javax.ws.rs.Consumes;
			import javax.ws.rs.POST;
			import javax.ws.rs.Path;
			import javax.ws.rs.Produces;
			import javax.ws.rs.core.MediaType;
			import org.eclipse.microprofile.rest.client.inject.RestClient;
			
			@RequestScoped
			@Path("«jaxRsClassPathAnnotation»")
			public class «compilationUnitName» «IF superClass != null»extends «superClass»«ENDIF»
		'''
		//public class «compilationUnitName» «IF superClass != null»extends «superClass»«ENDIF» «implementedClasses»
	}
	
	override body() {
		//		@«jaxRsClassDependencyInjectionAnnotation»(name="«jaxRsClassDependencyInjectionNameAttribute(dependencyInjection)»")
			'''		
			«FOR dependencyInjection : jaxRsClassDependencyInjection»
				@Inject
				@RestClient
				«field(dependencyInjection)»
			«ENDFOR»
			
			«FOR field : fields»
				«field(field)»
			«ENDFOR»
			
			«FOR constructor : constructors»
				«constructor(constructor)»
			«ENDFOR»
			
			«FOR method : methods»
				«method(method)»
			«ENDFOR»
			
		'''
	}
	
	def field(IJField field) {
		'''
		«field.visibility» «field.type» «field.name»;
		'''
	}
	
	def constructor(IJMethod method) {
		'''
		«method.visibilityModifier» «compilationUnitName» («method.parameters») «IF method.throwsType != null»throws «method.throwsType»«ENDIF»
		{
			«method.body»
		}
		
		'''
	}
	
	def method(IJMethod method) {
		'''
		«method.methodAnnotation»
		@POST
		@Consumes(MediaType.APPLICATION_JSON)
		@Path("«method.name»")
		@Produces(MediaType.APPLICATION_JSON)
		«method.visibilityModifier» «method.staticModifier» «method.returnType» «method.name» («method.parameters») «IF method.throwsType != null»throws «method.throwsType»«ENDIF»
		«IF method.body != null»
		{
			«method.body»
		}
		«ELSE»
		;
		«ENDIF»

		'''
	}
	
	
	def jaxRsClassDependencyInjectionNameAttribute(IJField field) {
		'''«field.type»'''
	}

    override jaxRsClassPathAnnotation() {
        provider.jaxRsClassPathAnnotation
    }

    override jaxRsClassDependencyInjectionAnnotation() {
        provider.jaxRsClassDependencyInjectionAnnotation
    }

    override jaxRsClassDependencyInjection() {
        provider.jaxRsClassDependencyInjection
    }
	
}
	
