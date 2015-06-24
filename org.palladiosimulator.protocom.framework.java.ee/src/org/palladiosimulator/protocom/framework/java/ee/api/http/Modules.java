package org.palladiosimulator.protocom.framework.java.ee.api.http;

import java.net.URI;
import java.util.LinkedList;

import javax.inject.Inject;
import javax.servlet.ServletContext;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.UriInfo;

import org.palladiosimulator.protocom.framework.java.ee.main.JsonHelper;
import org.palladiosimulator.protocom.framework.java.ee.modules.ContainerModule;
import org.palladiosimulator.protocom.framework.java.ee.modules.Module;
import org.palladiosimulator.protocom.framework.java.ee.modules.SystemModule;
import org.palladiosimulator.protocom.framework.java.ee.prototype.PrototypeBridge;

/**
 * API class for retrieving module data and starting modules.
 * @author Christian Klaussner
 */
@Path("/modules")
public final class Modules {
	@Context
	private ServletContext context;

	private static LinkedList<Module> modules;

	/**
	 * Constructs a new Modules object.
	 * @param bridge the bridge providing prototype data
	 */
	@Inject
	private Modules(PrototypeBridge bridge) {
		if (modules == null) {
			modules = new LinkedList<Module>();

			// Add containers to the list.
			for (PrototypeBridge.Container container : bridge.getContainers()) {
				String id = container.getId();
				PrototypeBridge.Allocation[] allocations = bridge.getAllocations(id);

				modules.add(new ContainerModule(container, allocations));
			}

			// Add system to the list.
			PrototypeBridge.System system = bridge.getSystem();
			modules.add(new SystemModule(system.getName(), system.getClassName()));
		}
	}

	/**
	 * Gets the base URL of the specified URI.
	 * @param uriInfo the URI whose base URL will be retrieved
	 * @return the base URL of the specified URI
	 */
	private String getBaseUrl(UriInfo uriInfo) {
		URI uri = uriInfo.getRequestUri();

		String scheme = uri.getScheme();
		String host = uri.getHost();
		String port = String.valueOf(uri.getPort());

		return scheme + "://" + host + ":" + port + context.getContextPath();
	}

	/**
	 * Gets all modules.
	 * @return a JSON array containing information about all modules
	 */
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public Response getModules() {
		return Response.ok(JsonHelper.toJson(modules)).build();
	}

	/**
	 * Starts the specified module.
	 * @param uriInfo the URI
	 * @param id the ID of the module
	 * @return an HTTP 200 response if the module was started successfully
	 */
	@GET
	@Path("{id}/start")
	public Response startModule(@Context UriInfo uriInfo, @PathParam("id") String id) {
		Module result = null;

		for (Module module : modules) {
			if (module.getId().equals(id)) {
				result = module;
				break;
			}
		}

		if (result == null) {
			return Response.status(404).build();
		}

		result.start(getBaseUrl(uriInfo));
		return Response.ok().build();
	}
}
