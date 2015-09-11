package org.palladiosimulator.protocom.framework.java.ee.webcontent;

import java.net.URL;

/**
 * The FrameworkFile class stores the data required for copying a framework file.
 * 
 * @author Christian Klaussner, Sebastian Lehrig
 */
public class FrameworkFile {

    private final URL url;
    private final String path;

    /**
     * Constructs a new FrameworkFile object.
     * 
     * @param url
     *            the source URL, e.g., URL("img/favicon.png")
     * @param path
     *            the destination path, e.g., "img"
     */
    public FrameworkFile(final URL url, final String path) {
        if (url == null) {
            throw new RuntimeException("Could not find url for path \"" + path + "\"");
        }

        this.url = url;
        this.path = path;
    }

    /**
     * Gets the source URL.
     * 
     * @return the source URL
     */
    public URL getUrl() {
        return this.url;
    }

    /**
     * Gets the destination path.
     * 
     * @return the destination path
     */
    public String getPath() {
        return this.path;
    }
}
