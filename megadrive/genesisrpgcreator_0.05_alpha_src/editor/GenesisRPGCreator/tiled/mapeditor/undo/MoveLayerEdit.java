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

package tiled.mapeditor.undo;


import java.awt.Point;
import javax.swing.undo.*;

import tiled.core.*;



public class MoveLayerEdit extends AbstractUndoableEdit
{
    private MapLayer layer;
    private Point moveDist;

    public MoveLayerEdit(MapLayer layer, Point moveDist) {
        this.layer = layer;
        this.moveDist = moveDist;
    }

    public void undo() throws CannotUndoException {
        super.undo();
        layer.translate(-moveDist.x, -moveDist.y);
    }

    public void redo() throws CannotRedoException {
        super.redo();
        layer.translate(moveDist.x, moveDist.y);
    }

    public String getPresentationName() {
        return "Move";
    }
}
