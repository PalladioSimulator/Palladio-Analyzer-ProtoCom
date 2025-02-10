package org.palladiosimulator.protocom.framework.java.ee.api.http;

import jakarta.servlet.ServletContext;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Context;

/**
 * API class for resetting the prototype status to "initial". Only for debugging purposes!
 * @author Christian Klaussner
 */
@Path("/reset")
public class Reset {
	@Context
	private ServletContext context;

	/**
	 * Resets the prototype status to "initial".
	 */
	@GET
	public void reset() {
		context.setAttribute("status", "initial");
	}
}
