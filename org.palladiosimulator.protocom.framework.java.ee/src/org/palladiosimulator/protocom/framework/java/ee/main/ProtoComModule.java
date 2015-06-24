package org.palladiosimulator.protocom.framework.java.ee.main;

import java.util.Set;

import javax.inject.Singleton;

import org.palladiosimulator.protocom.framework.java.ee.experiment.IExperiment;
import org.palladiosimulator.protocom.framework.java.ee.experiment.SensorFrameworkExperiment;
import org.palladiosimulator.protocom.framework.java.ee.prototype.PortServlet;
import org.palladiosimulator.protocom.framework.java.ee.storage.IStorage;
import org.palladiosimulator.protocom.framework.java.ee.storage.EcmStorage;
import org.reflections.Reflections;

import com.google.inject.servlet.ServletModule;
import com.sun.jersey.api.core.PackagesResourceConfig;
import com.sun.jersey.api.core.ResourceConfig;
import com.sun.jersey.guice.spi.container.servlet.GuiceContainer;

/**
 * The ProtoComModule class specifies all Guice bindings for the framwork and
 * generated performance prototypes.
 *
 * @author Christian Klaussner
 */
public class ProtoComModule extends ServletModule {
	private static final String API_PACKAGE =
		"org.palladiosimulator.protocom.framework.java.ee.api.http";

	@Override
	protected void configureServlets() {
		bind(IStorage.class).to(EcmStorage.class);
		bind(IExperiment.class).to(SensorFrameworkExperiment.class);

		registerApi();
		registerServlets();
	}

	/**
	 * Binds each HTTP API class to its respective path.
	 */
	private void registerApi() {
		ResourceConfig config = new PackagesResourceConfig(API_PACKAGE);

		for (Class<?> resource : config.getClasses()) {
			bind(resource);
		}

		serve("/api/*").with(GuiceContainer.class);
	}

	/**
	 * Scans the classes generated from the PCM repository for ports and binds each of
	 * them to its own path. This method is a replacement for web.xml servlet mappings
	 * and WebServlet annotations.
	 */
	@SuppressWarnings("rawtypes")
	private void registerServlets() {
		Set<Class<? extends PortServlet>> servlets;

		Reflections reflections = new Reflections("defaultrepository");
		servlets = reflections.getSubTypesOf(PortServlet.class);

		for (Class<? extends PortServlet> servlet : servlets) {
			String name = "/" + servlet.getSimpleName();

			bind(servlet).in(Singleton.class);
			serve(name).with(servlet);
		}
	}
}
