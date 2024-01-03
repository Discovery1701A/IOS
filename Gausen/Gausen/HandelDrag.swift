//
//  HandelDrag.swift
//  Gausen
//
//  Created by Anna Rieckmann on 24.12.23.
//

import SwiftUI
// Struct für das Verschieben der Reihen und Spalten
struct HandelDrag {
    @ObservedObject var modelView: ViewModel
    
    // Funktion zum Behandeln von Drag-Gesten für das Verschieben von Spalten
    func handleDragChangedColumn(value: DragGesture.Value, column: Int, size: CGSize) {
        // Zurücksetzen aller Zustände im ViewModel, die mit dem Dragging in Verbindung stehen
        modelView.varReset()
        modelView.resetSelection()
        // Markieren der gezogenen Spalte im ViewModel
        modelView.drag(column: column, bool: true)
        
        // Berechnen der Translation und der Index der gezogenen Spalte
        let translation = value.translation.width
        let columnWidth = size.width
        var draggedColumnIndex = column + Int((value.startLocation.x + translation) / columnWidth)
        
        // Anpassung des Index, wenn die Translation negativ ist (nach links)
        if Int(value.startLocation.x + translation) < 0 {
            if translation < 0 {
                draggedColumnIndex -= 1
            }
            if translation > 0 {
                draggedColumnIndex += 1
            }
        }
        
        // Markieren der gezogenen Spalte im ViewModel und Begrenzen der Position auf den erlaubten Bereich
        modelView.drag(column: draggedColumnIndex, bool: true)
        draggedColumnIndex = max(0, min(draggedColumnIndex, modelView.matrix.first?.count ?? 0))
       
        // Überprüfen und Durchführen des Spaltenwechsels im ViewModel
        if draggedColumnIndex != modelView.draggedColumn {
            modelView.columnSwitch(column1: modelView.draggedColumn ?? column, column2: draggedColumnIndex)
            modelView.draggedColumn = draggedColumnIndex
        }
        
        // Zurücksetzen des Drag-Zustands für nicht-gezogene Spalten
        for i in 0 ..< modelView.matrix.count where i != draggedColumnIndex {
            modelView.drag(column: i, bool: false)
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
        if Int(value.startLocation.y + translation) < 0 {
            if translation < 0 {
                draggedRowIndex -= 1
            }
            if translation > 0 {
                draggedRowIndex += 1
            }
        }
        
        // Markieren der gezogenen Zeile im ViewModel und Begrenzen der Position auf den erlaubten Bereich
        modelView.drag(row: draggedRowIndex, bool: true)
        draggedRowIndex = max(0, min(draggedRowIndex, modelView.matrix.first?.count ?? 0))
        
        // Überprüfen und Durchführen des Zeilenwechsels im ViewModel
        if draggedRowIndex != modelView.draggedRow {
            modelView.rowSwitch(row1: modelView.draggedRow ?? row, row2: draggedRowIndex)
            modelView.draggedRow = draggedRowIndex
        }
        
        // Zurücksetzen des Drag-Zustands für nicht-gezogene Zeilen
        for i in 0 ..< modelView.matrix.count where i != draggedRowIndex {
            modelView.drag(row: i, bool: false)
        }
    }
    
    // Funktion zum Behandeln des Endes der Drag-Geste
    func handleDragEnded() {
        // Zurücksetzen aller Zustände im ViewModel, die mit dem Dragging in Verbindung stehen
        modelView.varReset()
        // Zurücksetzen der gezogenen Spalten- und Zeilenindizes im ViewModel
        modelView.draggedColumn = nil
        modelView.draggedRow = nil
    }
}
