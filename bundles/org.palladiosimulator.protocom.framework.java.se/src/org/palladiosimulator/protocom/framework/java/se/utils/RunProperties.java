package org.palladiosimulator.protocom.framework.java.se.utils;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.Options;
import org.apache.log4j.Logger;

public class RunProperties {
    private final CommandLine cmdLine;
    private final Options options;
    private Properties propertyFile = null;

    private static final Logger LOGGER = org.apache.log4j.Logger.getRootLogger();

    public RunProperties(CommandLine cmdLine, Options options) {
        super();
        this.cmdLine = cmdLine;
        this.options = options;

        if (cmdLine.hasOption("f")) {
            propertyFile = new Properties();
            try {
                propertyFile.load(new FileInputStream(cmdLine.getOptionValue("f")));
            } catch (FileNotFoundException e) {
                LOGGER.error("Property file could not be found.", e);
                propertyFile = null;
            } catch (IOException e) {
                LOGGER.debug("Error reading property file.", e);
                propertyFile = null;
            }
        }
    }

    private String getPropertyFromFile(String key) {
        if (propertyFile != null) {
            return propertyFile.getProperty(key);
        }
        return null;
    }

    private boolean hasPropertyInFile(String key) {
        if (propertyFile != null) {
            if (propertyFile.getProperty(key) == null) {
                return false;
            } else {
                return true;
            }
        }
        return false;
    }

    private String getLongOpt(String opt) {
        String longOpt = opt;

        if (options.hasOption(opt)) {
            longOpt = options.getOption(opt).getLongOpt();
        }

        return longOpt;
    }

    public String getOptionValue(char opt) {
        String sOpt = "" + opt;
        return getOptionValue(sOpt);
    }

    public String getOptionValue(final String opt) {
        if (cmdLine.hasOption(opt)) {
            return cmdLine.getOptionValue(opt);
        } else {
            // look in file
            final String longOpt = getLongOpt(opt);

            if (hasPropertyInFile(longOpt)) {
                return getPropertyFromFile(longOpt);
            } else {
                return cmdLine.getOptionValue(opt);
            }
        }
    }

    public boolean hasOption(final char opt) {
        final String sOpt = "" + opt;
        return hasOption(sOpt);
    }

    public boolean hasOption(String opt) {
        if (hasPropertyInFile(getLongOpt(opt))) {
            return true;
        }
        return cmdLine.hasOption(opt);
    }

    public Object getOptionObject(char opt) {
        String sOpt = "" + opt;
        return getOptionObject(sOpt);
    }

    public Object getOptionObject(String opt) {
        return cmdLine.getOptionObject(opt);
    }
}
