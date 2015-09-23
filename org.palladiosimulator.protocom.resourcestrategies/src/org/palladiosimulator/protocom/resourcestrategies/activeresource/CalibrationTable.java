package org.palladiosimulator.protocom.resourcestrategies.activeresource;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.Serializable;

import javax.measure.quantity.Duration;

import org.apache.log4j.Logger;
import org.jscience.physics.amount.Amount;

/**
 * Struct to represent a single entry in the calibration table of the load generators. It is a tuple
 * <TargetTime, Parameter>
 * 
 * @author Steffen Becker, Thomas Zolynski, Sebastian Lehrig
 *
 */
class CalibrationEntry implements Serializable {

    private static final long serialVersionUID = -1969713798721640687L;

    final private Amount<Duration> targetTime;
    final private long parameter;

    /**
     * Constructor
     * 
     * @param targetTime
     *            The time (in ms) which the workload generator should run and generate load for the
     *            given parameter
     * @param parameter
     *            The load generator's parameter for which the algorithm runs targetTime
     *            milliseconds
     */
    public CalibrationEntry(final Amount<Duration> targetTime, final long parameter) {
        super();
        this.targetTime = targetTime;
        this.parameter = parameter;
    }

    /**
     * @return Target time in ms
     */
    public Amount<Duration> getTargetTime() {
        return this.targetTime;
    }

    /**
     * @return Algorithm's parameter for which the algorithm runs target time milliseconds
     */
    public long getParameter() {
        return this.parameter;
    }

    @Override
    public String toString() {
        return AbstractDemandStrategy.formatDuration(this.targetTime) + "\t | \t" + this.parameter;
    }
}

/**
 * Class representing the calibration table. Stores a collection of calibration entries.
 * 
 * @author Tobias Denker, Anne Koziolek, Steffen Becker, Thomas Zolynski, Sebastian Lehrig
 */
public class CalibrationTable {

    /** Default number of tuples <targetTime, parameter> to store in the calibration table */
    public static final int DEFAULT_CALIBRATION_TABLE_SIZE = 11;

    protected CalibrationEntry[] table;

    private static final Logger LOGGER = Logger.getLogger(AbstractDemandStrategy.class.getName());

    /**
     * Private constructor. Used when created by loading an existing calibration table.
     */
    public CalibrationTable() {
        this.table = new CalibrationEntry[DEFAULT_CALIBRATION_TABLE_SIZE];
    }

    /**
     * Constructor. New calibration table with given size.
     * 
     * @param tableSize
     *            size of the calibration table
     */
    public CalibrationTable(final int tableSize) {
        this.table = new CalibrationEntry[tableSize];
    }

    /**
     * Loads calibration from config file
     * 
     * @return The loaded calibration file or null if the file could not be loaded
     */
    public static CalibrationTable load(final File configFile) {
        CalibrationTable calibrationTable = null;

        // tests whether the calibration file exists and can be loaded
        if (configFile.exists()) {
            LOGGER.debug("Loaded calibration from '" + configFile + "'");

            calibrationTable = new CalibrationTable();

            InputStream fis = null;
            try {
                fis = new FileInputStream(configFile);
                final ObjectInputStream o = new ObjectInputStream(fis);
                calibrationTable.setTable((CalibrationEntry[]) o.readObject());
                o.close();
            } catch (final IOException e) {
                LOGGER.error("Error while loading " + configFile, e);
                throw new RuntimeException(e);

            } catch (final ClassNotFoundException e) {
                LOGGER.error("Error while reading " + configFile, e);
                throw new RuntimeException(e);
            } catch (final Exception e) {
                LOGGER.error("Error while reading " + configFile, e);
                throw new RuntimeException(e);

            } finally {
                try {
                    fis.close();
                } catch (final Exception e) {
                    throw new RuntimeException(e);
                }
            }

        } else {
            LOGGER.debug(configFile + " not existing yet");
        }

        return calibrationTable;
    }

    /**
     * Saves calibration to config file. Config file uses a Java object stream to serialise the
     * calibration table.
     */
    public void save(final File configFile) {
        LOGGER.info("Saving calibration to '" + configFile + "'");
        OutputStream fos = null;
        try {
            fos = new FileOutputStream(configFile);

            final ObjectOutputStream o = new ObjectOutputStream(fos);
            o.writeObject(this.table);
            o.close();
        } catch (final IOException e) {
            LOGGER.error("Error while writing calibration data", e);
        } finally {
            try {
                fos.close();
            } catch (final Exception e) {
            }
        }
    }

    /**
     * Serializes the calibration table to a byte array.
     * 
     * @return a byte array containing the serialized calibration table
     */
    public byte[] toBinary() {
        final ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            final ObjectOutputStream stream = new ObjectOutputStream(out);
            stream.writeObject(this.table);
        } catch (final IOException e) {
            e.printStackTrace();
        }

        return out.toByteArray();
    }

    /**
     * Creates a calibration table from a byte array.
     * 
     * @param binary
     *            a byte array containing the serialized calibration table
     * @return a new CalibrationTable object
     */
    public static CalibrationTable fromBinary(final byte[] binary) {
        final CalibrationTable result = new CalibrationTable();
        CalibrationEntry[] table = null;

        final ByteArrayInputStream in = new ByteArrayInputStream(binary);

        try {
            final ObjectInputStream stream = new ObjectInputStream(in);
            table = (CalibrationEntry[]) stream.readObject();
            result.setTable(table);
        } catch (final IOException e) {
            e.printStackTrace();
        } catch (final ClassNotFoundException e) {
            e.printStackTrace();
        }

        return result;
    }

    private void setTable(final CalibrationEntry[] table) {
        this.table = table;
    }

    /**
     * Returns the calibration entry for given number.
     * 
     * @param entryNumber
     * @return
     */
    public CalibrationEntry getEntry(final int entryNumber) {
        return this.table[entryNumber];
    }

    /**
     * Creates a new calibration entry.
     * 
     * @param entryNumber
     *            entry number (position in table)
     * @param targetTime
     * @param parameter
     */
    public void addEntry(final int entryNumber, final Amount<Duration> targetTime, final long parameter) {
        this.table[entryNumber] = new CalibrationEntry(targetTime, parameter);
    }

    /**
     * Returns the size of the calibration table.
     * 
     * @return
     */
    public int size() {
        return this.table.length;
    }

}
