//
//  HandelDrag.swift
//  Gausen
//
//  Created by Anna Rieckmann on 24.12.23.
//
// Struct für das Verschieben der Reihen und Spalten

import SwiftUI

struct HandleDrag {
    @ObservedObject var modelView: ViewModel
    
    // Funktion zum Behandeln von Drag-Gesten für das Verschieben von Spalten
    func handleDragChangedColumn(value: DragGesture.Value, column: Int, size: CGSize) {
        // Zurücksetzen aller Zustände im ViewModel, die mit dem Dragging in Verbindung stehen
        modelView.varReset()
        modelView.resetSelection()
        // Markieren der gezogenen Spalte im ViewModel
        modelView.drag(item: column, bool: true, rowOrColumn: .column)
        
        // Berechnen der Translation und des Index der gezogenen Spalte
        let translation = value.translation.width
        let columnWidth = size.width
        var draggedColumnIndex = column + Int((value.startLocation.x + translation) / columnWidth)
        
        // Anpassung des Index, wenn die Translation negativ ist (nach links)
        if value.startLocation.x + translation < 0 {
            draggedColumnIndex -= 1
        } else if value.startLocation.x + translation > 0 {
            draggedColumnIndex += 1
        }
        
        // Markieren der gezogenen Spalte im ViewModel und Begrenzen der Position auf den erlaubten Bereich
        modelView.drag(item: draggedColumnIndex, bool: true, rowOrColumn: .column)
        draggedColumnIndex = max(0, min(draggedColumnIndex, modelView.matrix.first?.count ?? 0))
       
        // Überprüfen und Durchführen des Spaltenwechsels im ViewModel
        if draggedColumnIndex != modelView.draggedColumn {
            withAnimation {
                modelView.columnSwitch(column1: modelView.draggedColumn ?? column, column2: draggedColumnIndex)
            }
            modelView.draggedColumn = draggedColumnIndex
                
        }
        
        // Zurücksetzen des Drag-Zustands für nicht-gezogene Spalten
        for i in 0 ..< (modelView.matrix.first?.count ?? 0) where i != draggedColumnIndex {
            modelView.drag(item: i, bool: false, rowOrColumn: .column)
        }
    }

    // Funktion zum Behandeln von Drag-Gesten für das Verschieben von Zeilen
    func handleDragChangedRow(value: DragGesture.Value, row: Int, size: CGSize) {
        // Zurücksetzen aller Zustände im ViewModel, die mit dem Dragging in Verbindung stehen
        modelView.varReset()
        modelView.resetSelection()
        // Berechnen der Translation und des Index der gezogenen Zeile
        let translation = value.translation.height
        let rowHeight = size.height
        var draggedRowIndex = row + Int((value.startLocation.y + translation + CGFloat(row)) / rowHeight)
        
        // Anpassung des Index, wenn die Translation negativ ist (nach oben)
        if value.startLocation.y + translation < 0 {
            draggedRowIndex -= 1
        } else if value.startLocation.y + translation > 0 {
            draggedRowIndex += 1
        }
        
        // Markieren der gezogenen Zeile im ViewModel und Begrenzen der Position auf den erlaubten Bereich
        modelView.drag(item: draggedRowIndex, bool: true, rowOrColumn: .row)
        draggedRowIndex = max(0, min(draggedRowIndex, modelView.matrix.first?.count ?? 0))
        
        // Überprüfen und Durchführen des Zeilenwechsels im ViewModel
        if draggedRowIndex != modelView.draggedRow {
            withAnimation {
                modelView.rowSwitch(row1: modelView.draggedRow ?? row, row2: draggedRowIndex)
            }
            modelView.draggedRow = draggedRowIndex
        }
        
        // Zurücksetzen des Drag-Zustands für nicht-gezogene Zeilen
        for i in 0 ..< modelView.matrix.count where i != draggedRowIndex {
            modelView.drag(item: i, bool: false, rowOrColumn: .row)
        }
    }
    
    // Funktion zum Behandeln des Endes der Drag-Geste
    func handleDragEnded() {
        // Zurücksetzen aller Zustände der Felder, die mit dem Dragging in Verbindung stehen
        modelView.varReset()
        // Zurücksetzen der gezogenen Spalten- und Zeilenindizes im ViewModel
        modelView.draggedColumn = nil
        modelView.draggedRow = nil
    }
}