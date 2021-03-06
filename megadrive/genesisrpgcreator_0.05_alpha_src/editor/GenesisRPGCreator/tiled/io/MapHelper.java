/*
 *  Tiled Map Editor, (c) 2004
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 * 
 *  Adam Turk <aturk@biggeruniverse.com>
 *  Bjorn Lindeijer <b.lindeijer@xs4all.nl>
 */

package tiled.io;


import java.io.IOException;
import java.util.Iterator;
import java.util.Stack;

import javax.swing.JOptionPane;

import tiled.core.Map;
import tiled.io.xml.XMLMapTransformer;
import tiled.io.xml.XMLMapWriter;
import tiled.mapeditor.plugin.PluginClassLoader;
import tiled.util.TiledConfiguration;

public class MapHelper {
    
    private static PluginClassLoader pluginLoader;
    
    public static void init(PluginClassLoader p) {
        pluginLoader = p;
    }
    
    /**
     * Saves the current map. Use the extension (.xxx) of the filename to determine
     * the plugin to use when writing the file. Throws an exception when the extension
     * is not supported by either the TMX writer or a plugin.
     *
     * @param filename Filename to save the current map to.
     * @see MapWriter#writeMap(Map, String)
     * @exception Exception
     */
    public static void saveMap(Map currentMap, String filename) throws Exception {

            MapWriter mw = null;
            if (filename.endsWith("tmx")) {
                // Override, so people can't overtake our format
                mw = new XMLMapWriter();
            } else {
                mw = (MapWriter)pluginLoader.getWriterFor(
                        filename.substring(filename.lastIndexOf('.') + 1));
            }

            if (mw != null) {
                Stack errors = new Stack();
                mw.setErrorStack(errors);
                mw.writeMap(currentMap, filename);
                currentMap.setFilename(filename);
                reportPluginMessages(errors);
            } else {
               throw new Exception("Unsupported map format");
            }
    }
    
    /**
     * Loads a map. Use the extension (.xxx) of the filename to determine
     * the plugin to use when reading the file. Throws an exception when the extension
     * is not supported by either the TMX writer or a plugin.
     *
     * @param file filename of map to load
     * @return A new Map instance, loaded from the specified file by a plugin
     * @see MapReader#readMap(String)
     */
    public static Map loadMap(String file) throws Exception {
        Map ret = null;
        try {
            MapReader mr = null;
            if (file.endsWith(".tmx")) {
                // Override, so people can't overtake our format
                mr = new XMLMapTransformer();
            } else {
                mr = (MapReader)pluginLoader.getReaderFor(
                        file.substring(file.lastIndexOf('.') + 1));
            }

            if (mr != null) {
                Stack errors = new Stack();
                mr.setErrorStack(errors);
                ret = mr.readMap(file);
                reportPluginMessages(errors);
            } else {
                throw new Exception("Unsupported map format");
            }
        } catch (IOException e) {
            JOptionPane.showMessageDialog(null,
                    e.getMessage() + (e.getCause() != null ? "\nCause: " +
                        e.getCause().getMessage() : ""),
                    "Error while loading map",
                    JOptionPane.ERROR_MESSAGE);
            e.printStackTrace();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null,
                    "Error while loading " + file + ": " +
                    e.getMessage() + (e.getCause() != null ? "\nCause: " +
                        e.getCause().getMessage() : ""),
                    "Error while loading map",
                    JOptionPane.ERROR_MESSAGE);
            e.printStackTrace();
        }

        return ret;
    }
    
    /**
     * Reports messages from the plugin to the user in a dialog
     * 
     * @param s A Stack which was used by the plugin to record any messages it had for the user
     */
    private static void reportPluginMessages(Stack s) {
        // TODO: maybe have a nice dialog with a scrollbar, in case there are a
        // lot of messages...
        if (TiledConfiguration.getInstance().keyHasValue("tiled.report.io", 1)) {
            if (s.size() > 0) {
                Iterator itr = s.iterator();
                String warnings = "";
                while (itr.hasNext()) {
                    String warn = (String) itr.next();
                    warnings = warnings + warn + "\n";
                }
                JOptionPane.showMessageDialog(null,  warnings,
                        "Loading Messages",
                        JOptionPane.INFORMATION_MESSAGE);
            }
        }
    }
}
