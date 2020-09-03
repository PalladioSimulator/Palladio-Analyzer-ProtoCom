package org.palladiosimulator.protocom.traverse.microprofile.system

import org.palladiosimulator.protocom.lang.java.impl.JClass
import org.palladiosimulator.protocom.lang.java.impl.JInterface
import org.palladiosimulator.protocom.lang.manifest.impl.JseManifest
import org.palladiosimulator.protocom.lang.properties.impl.BuildProperties
import org.palladiosimulator.protocom.lang.xml.impl.Classpath
import org.palladiosimulator.protocom.lang.xml.impl.PluginXml
import org.palladiosimulator.protocom.tech.rmi.repository.PojoComposedStructureContextClass
import org.palladiosimulator.protocom.tech.rmi.repository.PojoComposedStructureContextInterface
import org.palladiosimulator.protocom.tech.rmi.repository.PojoComposedStructureInterface
import org.palladiosimulator.protocom.tech.rmi.repository.PojoComposedStructurePortClass
import org.palladiosimulator.protocom.tech.rest.system.JaxRsBuildProperties
import org.palladiosimulator.protocom.tech.rmi.system.PojoClasspath
import org.palladiosimulator.protocom.tech.rmi.system.PojoManifest
import org.palladiosimulator.protocom.tech.rmi.system.PojoPluginXml
import org.palladiosimulator.protocom.tech.rmi.system.PojoSystemClass
import org.palladiosimulator.protocom.traverse.framework.system.XSystem
import org.palladiosimulator.protocom.tech.rest.system.JaxRsPom
import org.palladiosimulator.protocom.lang.xml.impl.MicroprofilePOM
import org.palladiosimulator.pcm.core.composition.AssemblyConnector
import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.protocom.lang.java.impl.JeeClass
import org.palladiosimulator.protocom.tech.iiop.repository.JavaEEIIOPBasicComponentClass
import org.palladiosimulator.protocom.lang.java.impl.MicroprofileClass
import org.palladiosimulator.protocom.tech.rest.repository.JaxRsBasicComponentClass
import org.palladiosimulator.protocom.tech.rest.system.JaxRsServerXML
import org.palladiosimulator.protocom.lang.xml.impl.MicroprofileServerXML
import org.palladiosimulator.protocom.lang.xml.impl.MicroprofileJvmOptions
import org.palladiosimulator.protocom.tech.rest.system.JaxRsJvmOptions
import org.palladiosimulator.protocom.tech.rest.system.JaxRsWebXML
import org.palladiosimulator.protocom.lang.xml.impl.MicroprofileWebXML

/**
 * An System translates into the following Java compilation units:
 * <ul>
 * 	<li> a class used to setup the assembly (a System is a Composed Structure),
 * 	<li> an interface for this component's class,
 * 	<li> a context class for assembly (basically unused, can be removed?),
 * 	<li> an interface for the context class,
 *  <li> a class for each component's port, used by the Usage Scenario. TODO: Move to traverse
 * </ul>
 * 
 * @author Thomas Zolynski
 */
class MicroprofileSystem extends XSystem {

	override generate() {
		val assemblyConnectorSet = entity.connectors__ComposedStructure.filter(typeof(AssemblyConnector)).toSet
		val repositoryComponentList = entity.assemblyContexts__ComposedStructure

		repositoryComponentList.filter[BasicComponent.isInstance(it.encapsulatedComponent__AssemblyContext)].map[
			it.encapsulatedComponent__AssemblyContext as BasicComponent].forEach[
			generatedFiles.add(
				injector.getInstance(typeof(MicroprofileClass)).createFor(
					new JaxRsBasicComponentClass((it), assemblyConnectorSet)))]


		// Interface. Necessity of this one is debatable. For now, it is included, because the current ProtoCom uses it as well.
		generatedFiles.add(injector.getInstance(typeof(JInterface)).createFor(new PojoComposedStructureInterface(entity)))

		// Class for this component.
		//generatedFiles.add(injector.getInstance(typeof(JClass)).createFor(new PojoSystemClass(entity))) 
	
		// Context pattern.
		//generatedFiles.add(injector.getInstance(typeof(JClass)).createFor(new PojoComposedStructureContextClass(entity)))
		//generatedFiles.add(injector.getInstance(typeof(JInterface)).createFor(new PojoComposedStructureContextInterface(entity)))

		// Ports. See TODO above.
		/*entity.providedRoles_InterfaceProvidingEntity.forEach[
			generatedFiles.add(injector.getInstance(typeof(JClass)).createFor(new PojoComposedStructurePortClass(it)))
		]*/
		
		//Manifest File
		generatedFiles.add(injector.getInstance(typeof(JseManifest)).createFor(new PojoManifest(entity)))
		
		//Plugin.xml file
		generatedFiles.add(injector.getInstance(typeof(PluginXml)).createFor(new PojoPluginXml(entity)))
		
		//Build.properties file
		generatedFiles.add(injector.getInstance(typeof(BuildProperties)).createFor(new JaxRsBuildProperties(entity)))

		//Classpath file
		generatedFiles.add(injector.getInstance(typeof(Classpath)).createFor(new PojoClasspath(entity)))

		//POM
		generatedFiles.add(injector.getInstance(typeof(MicroprofilePOM)).createFor(new JaxRsPom(entity)))

		//ServerXML
		generatedFiles.add(injector.getInstance(typeof(MicroprofileServerXML)).createFor(new JaxRsServerXML(entity)))

		//jvm.options		
		generatedFiles.add(injector.getInstance(typeof(MicroprofileJvmOptions)).createFor(new JaxRsJvmOptions(entity)))
		
		//WebXML
		generatedFiles.add(injector.getInstance(typeof(MicroprofileWebXML)).createFor(new JaxRsWebXML(entity)))
		
	}
}
