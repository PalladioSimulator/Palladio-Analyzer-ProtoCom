package org.palladiosimulator.protocom.tech.rest.repository

import java.util.HashSet
import java.util.Set
import org.palladiosimulator.pcm.core.composition.AssemblyConnector
import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.pcm.repository.InfrastructureProvidedRole
import org.palladiosimulator.pcm.repository.OperationProvidedRole
import org.palladiosimulator.pcm.seff.ResourceDemandingBehaviour
import org.palladiosimulator.protocom.lang.java.impl.JField
import org.palladiosimulator.protocom.lang.java.impl.JMethod
import org.palladiosimulator.protocom.lang.java.util.JavaNames
import org.palladiosimulator.protocom.lang.java.util.PcmCommons
import org.palladiosimulator.protocom.tech.rest.JaxRsClass
import org.palladiosimulator.protocom.tech.rest.util.PcmRESTProtoAction

/**
 * @author Sebastian Lehrig
 */
class JaxRsBasicComponentClass extends JaxRsClass<BasicComponent> {
	
	Set<AssemblyConnector> assemblyConnectors = new HashSet<AssemblyConnector>();
	
	new(BasicComponent pcmEntity) {
		super(pcmEntity)
	}
	
	new(BasicComponent pcmEntity, Set<AssemblyConnector> assemblyConnectors) {
		super(pcmEntity)
		this.assemblyConnectors = assemblyConnectors
	}
	
	override interfaces() {
		//#[ JavaNames::interfaceName(pcmEntity) ]
	}
	
	override constructors() {
		#[
			new JMethod()
				.withParameters("String assemblyContextID")
				.withImplementation(
					'''
					this.assemblyContextID = assemblyContextID;
					
					«FOR resource : pcmEntity.passiveResource_BasicComponent»
					passive_resource_«JavaNames::javaVariableName(resource.entityName)» = new java.util.concurrent.Semaphore(de.uka.ipd.sdq.simucomframework.variables.StackContext.evaluateStatic("«JavaNames::specificationString(resource.capacity_PassiveResource.specification)»", Integer.class), true);
					«ENDFOR»
					'''
					/* «FOR role : pcmEntity.providedRoles_InterfaceProvidingEntity.filter[OperationProvidedRole.isInstance(it)].map[it as OperationProvidedRole] BEFORE "try {" AFTER "} catch (java.rmi.RemoteException e) {  }"»
						«JavaNames::portMemberVar(role)» = new «JavaNames::fqnPort(role)»(this, assemblyContextID);
					«ENDFOR»
					
					«FOR role : pcmEntity.providedRoles_InterfaceProvidingEntity.filter[InfrastructureProvidedRole.isInstance(it)].map[it as InfrastructureProvidedRole] BEFORE "try {" AFTER "} catch (java.rmi.RemoteException e) {  }"»
						«JavaNames::portMemberVar(role)» = new «JavaNames::fqnPort(role)»(this, assemblyContextID);
					«ENDFOR»*/
				)
		]
	}
	
	override fields() {
		val results = newLinkedList

		// Context & ComponentFrame
		results += #[
		//	new JField()
		//		.withName("myContext")
		//		.withType(JavaNames::fqnContextInterface(pcmEntity)),
				
			new JField()
				.withName("myComponentStackFrame")
				.withType(PcmCommons::stackframeType),
				
			new JField()
				.withName("myDefaultComponentStackFrame")
				.withType(PcmCommons::stackframeType)
		]
		
		// Assembly context
		results += #[
			new JField()
				.withName("assemblyContextID")
				.withType("String")
		]
		
		// Provided ports
		/*results += pcmEntity.providedRoles_InterfaceProvidingEntity.filter[OperationProvidedRole.isInstance(it)].map[it as OperationProvidedRole].map[
			new JField()
				.withName(JavaNames::portMemberVar(it))
				.withType(JavaNames::fqn(it.providedInterface__OperationProvidedRole))
		]*/
		
		results += pcmEntity.providedRoles_InterfaceProvidingEntity.filter[InfrastructureProvidedRole.isInstance(it)].map[it as InfrastructureProvidedRole].map[
			new JField()
				.withName(JavaNames::portMemberVar(it))
				.withType(JavaNames::fqn(it.providedInterface__InfrastructureProvidedRole))
		]
		
		// Passive resources
		results += pcmEntity.passiveResource_BasicComponent.map[
			new JField()
				.withName("passive_resource_" + JavaNames::javaVariableName(it.entityName))
				.withType("java.util.concurrent.Semaphore")
		]

		results
	}
	
	override methods() {
		val results = newLinkedList
		
		// Context & ComponentFrame
		results += #[
			new JMethod()
				.withName("setContext")
				.withParameters("Object myContext")
			//	.withImplementation("this.myContext = (" + JavaNames::fqnContextInterface(pcmEntity) + ") myContext;"),
				.withImplementation("// TODO Auto-generated method"),
				
			new JMethod()
				.withName("setComponentFrame")
				.withParameters(PcmCommons::stackframeParameterList)
				.withImplementation("this.myComponentStackFrame = myComponentStackFrame; this.myDefaultComponentStackFrame = new de.uka.ipd.sdq.simucomframework.variables.stackframe.SimulatedStackframe<Object>();")
		]

		// SEFFs
		results += pcmEntity.serviceEffectSpecifications__BasicComponent.map[
			new JMethod()
				.withName(JavaNames::serviceName(it.describedService__SEFF))
				.withReturnType(PcmCommons::stackframeType)
				.withParameters(PcmCommons::stackContextParameterList)
				.withImplementation('''
					«new PcmRESTProtoAction().actions((it as ResourceDemandingBehaviour).steps_Behaviour.get(0))»
					return null;
					''')
		]
		
		// Provided ports getter for OperationProvidedRoles
		/*results += pcmEntity.providedRoles_InterfaceProvidingEntity.filter[OperationProvidedRole.isInstance(it)].map[
			new JMethod()
				.withName(JavaNames::portGetter(it))
				.withReturnType(JavaNames::fqn((it as OperationProvidedRole).providedInterface__OperationProvidedRole))
				.withImplementation("return " + JavaNames::portMemberVar(it as OperationProvidedRole) + ";")
		]*/
		
		// Main method. 
		// TODO: extract common implementation with system.
		/*results += new JMethod()
			.withName("main")
			.withParameters("String[] args")
			.withStaticModifier		
			.withImplementation('''
				String ip = org.palladiosimulator.protocom.framework.java.se.registry.RmiRegistry.getIpFromArguments(args);
				int port = org.palladiosimulator.protocom.framework.java.se.registry.RmiRegistry.getPortFromArguments(args);
				
				String assemblyContext = org.palladiosimulator.protocom.framework.java.se.AbstractMain.getAssemblyContextFromArguments(args);
				
				org.palladiosimulator.protocom.framework.java.se.registry.RmiRegistry.setRemoteAddress(ip);
				org.palladiosimulator.protocom.framework.java.se.registry.RmiRegistry.setRegistryPort(port);
				
				new «JavaNames::fqn(pcmEntity)»(assemblyContext);
			''')*/
		
		results	
	}

    override jaxRsClassPathAnnotation() {
        JavaNames::javaName(pcmEntity)
        // TODO Annotation 
        //throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }

    override jaxRsClassDependencyInjectionAnnotation() {
        "test"
        //throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }

    override jaxRsClassDependencyInjection() {
        val basicComponentAssemblyConnectors = assemblyConnectors.filter[
			it.requiredRole_AssemblyConnector.requiringEntity_RequiredRole.equals(pcmEntity)]
		val results = newLinkedList

		for (assemblyConnector : basicComponentAssemblyConnectors) {
			var assemblyProvidedRole = assemblyConnector.providedRole_AssemblyConnector
			results += #[
				new JField().withName(JavaNames::javaName(assemblyConnector.requiredRole_AssemblyConnector).toFirstLower).
					withType(
						//JavaNames::javaName(assemblyProvidedRole.providingEntity_ProvidedRole).toLowerCase +
						//	".interfaces.ejb." +
						"interfaces." +
							JavaNames::javaName(assemblyProvidedRole.providedInterface__OperationProvidedRole))
			]
		}

		results
    }
	
}