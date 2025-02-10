package org.palladiosimulator.protocom.framework.java.ee.api.http;

import java.util.HashMap;

import jakarta.servlet.ServletContext;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;

import org.palladiosimulator.protocom.framework.java.ee.main.JsonHelper;

/**
 * API class for retrieving the prototype status.
 * @author Christian Klaussner
 */
@Path("/status")
public class Status {
	@Context
	private ServletContext context;

	/**
	 * Gets the status ("initial", "started", or "calibrating") of the prototype.
	 * @return a JSON object describing the status
	 */
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String getStatus() {
		String value = (String) context.getAttribute("status");

		if (value == null) {
			value = "initial";
			context.setAttribute("status", value);
		}

		HashMap<String, Object> status = new HashMap<String, Object>();
		status.put("status", value);

		return JsonHelper.toJson(status);
	}
}
