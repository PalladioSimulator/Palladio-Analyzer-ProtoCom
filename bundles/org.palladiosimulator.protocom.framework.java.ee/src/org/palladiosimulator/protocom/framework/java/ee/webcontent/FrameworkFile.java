package org.palladiosimulator.protocom.framework.java.ee.webcontent;

import java.io.File;
import java.net.URL;

/**
 * The FrameworkFile class stores the data required for copying a framework file.
 * 
 * @author Christian Klaussner, Sebastian Lehrig
 */
public class FrameworkFile {

    private final File inputFile;
    private final URL inputURL;

    private final String path;

    /**
     * Constructs a new FrameworkFile object.
     * 
     * @param url
     *            the source URL, e.g., URL("img/favicon.png")
     * @param path
     *            the destination path, e.g., "img"
     */
    public FrameworkFile(final URL inputURL, final String path) {
        if (inputURL == null) {
            throw new RuntimeException("Could not find URL for path \"" + path + "\"");
        }

        this.inputFile = null;
        this.inputURL = inputURL;
        this.path = path;
    }

    /**
     * Constructs a new FrameworkFile object.
     * 
     * @param url
     *            the source URL, e.g., URL("img/favicon.png")
     * @param path
     *            the destination path, e.g., "img"
     */
    public FrameworkFile(final File inputFile, final String path) {
        if (inputFile == null) {
            throw new RuntimeException("Could not find file for path \"" + path + "\"");
        }

        this.inputFile = inputFile;
        this.inputURL = null;
        this.path = path;
    }

    /**
     * Gets the source URL.
     * 
     * @return the source URL
     */
    public File getInputFile() {
        return this.inputFile;
    }

    /**
     * Gets the source URL.
     * 
     * @return the source URL
     */
    public URL getInputUrl() {
        return this.inputURL;
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
