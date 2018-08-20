package org.palladiosimulator.protocom.framework.java.ee.webcontent;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.Platform;
import org.eclipse.osgi.util.ManifestElement;
import org.osgi.framework.Bundle;
import org.osgi.framework.BundleException;
import org.osgi.framework.Constants;
import org.palladiosimulator.commons.eclipseutils.FileHelper;

/**
 * The FileProvider class is used to retrieve WebContent files during transformation.
 * 
 * @author Christian Klaussner, Sebastian Lehrig
 */
public class FileProvider {

    /**
     * Returns a file in the framework as specified in the index.
     * 
     * @param source
     *            the name of the file
     * @param path
     *            the path of the file
     * @return a file in the framework
     */
    private FrameworkFile processIndex(final String source, final String path) {
        final URL url = getClass().getResource("files/" + source);
        if (url == null) {
            throw new RuntimeException("Could not find file \"" + source + "\"");
        }

        final String absolute = path + '/' + source.substring(source.lastIndexOf('/') + 1);

        return new FrameworkFile(url, absolute);
    }

    /**
     * Returns a file in the framework as specified in the index.
     * 
     * @param source
     *            the name of the file
     * @param path
     *            the path of the file
     * @return a file in the framework
     */
    private FrameworkFile processPlugin(final String source) {
        final String target = "WEB-INF/lib/" + FileHelper.getPluginJarFileName(source);

        return new FrameworkFile(FileHelper.getPluginJarFile(source), target);
    }

    /**
     * Gets all framework files specified in the index.
     * 
     * @return a list of files in the framework
     */
    public List<FrameworkFile> getFrameworkFiles() {
        final List<FrameworkFile> files = new LinkedList<FrameworkFile>();
        String line;

        try (final BufferedReader reader = getReader("files.index")) {
            while ((line = reader.readLine()) != null) {
                if (line.startsWith("#") || line.trim().isEmpty()) {
                    continue;
                }

                final String[] comp = line.split("->");

                if (comp.length != 2) {
                    throw new RuntimeException("Wrong index file format");
                } else {
                    files.add(processIndex(comp[0].trim(), comp[1].trim()));
                }
            }
        } catch (final IOException e) {
            throw new RuntimeException(e);
        }

        try (final BufferedReader reader = getReader("libraries.index")) {
            while ((line = reader.readLine()) != null) {
                if (line.startsWith("#") || line.trim().isEmpty()) {
                    continue;
                }

                files.add(processPlugin(line.trim()));
            }
        } catch (final IOException e) {
            throw new RuntimeException(e);
        }

        return files;
    }

    private BufferedReader getReader(final String file) {
        try {
            return new BufferedReader(new InputStreamReader(getClass().getResource(file).openStream()));
        } catch (final IOException e) {
            throw new RuntimeException("Index file not found", e);
        }
    }

    /**
     * Fills the given set with the dependencies of the specified bundle. Used only for debugging
     * purposes.
     * 
     * @see http://www.eclipsezone.com/eclipse/forums/t49415.html
     * @param pluginID
     *            the name of the bundle
     * @param result
     *            the set used to store the names of the bundle's dependencies
     */
    public void getDependencies(final String pluginID, final Set<String> result) {
        final Bundle plugin = Platform.getBundle(pluginID);

        if (plugin == null) {
            return;
        }

        final String requires = plugin.getHeaders().get(Constants.REQUIRE_BUNDLE);
        String jar = "<unknown>";

        try {
            jar = FileLocator.getBundleFile(plugin).getName();
        } catch (final IOException e) {
            e.printStackTrace();
        }

        try {
            ManifestElement[] elements;
            elements = ManifestElement.parseHeader(Constants.BUNDLE_CLASSPATH, requires);

            if (elements != null) {
                for (final ManifestElement element : elements) {
                    final String value = element.getValue();

                    result.add(value + " (" + jar + ")");
                    getDependencies(value, result);
                }
            }
        } catch (final BundleException e) {
            e.printStackTrace();
        }
    }
}
