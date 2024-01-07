//
//  HandleDrag.swift
//  Gausen
//
//  Created by Anna Rieckmann on 24.12.23.
//
// Struct für das Verschieben der Reihen und Spalten

import SwiftUI

struct HandleDrag {
    @ObservedObject var viewModel: ViewModel
    
    // Funktion zum Behandeln von Drag-Gesten für das Verschieben von Spalten
    func handleDragChangedColumn(value: DragGesture.Value, column: Int, size: CGSize) {
        // Zurücksetzen aller Zustände im ViewModel, die mit dem Dragging in Verbindung stehen
        viewModel.varReset()
        viewModel.resetSelection()
        // Markieren der gezogenen Spalte im ViewModel
        viewModel.drag(item: column, bool: true, rowOrColumn: .column)
        
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
        viewModel.drag(item: draggedColumnIndex, bool: true, rowOrColumn: .column)
        draggedColumnIndex = max(0, min(draggedColumnIndex, viewModel.matrix.first?.count ?? 0))
       
        // Überprüfen und Durchführen des Spaltenwechsels im ViewModel
        if draggedColumnIndex != viewModel.draggedColumn {
            withAnimation {
                viewModel.columnSwitch(column1: viewModel.draggedColumn ?? column, column2: draggedColumnIndex)
            }
            viewModel.draggedColumn = draggedColumnIndex
        }
        
        // Zurücksetzen des Drag-Zustands für nicht-gezogene Spalten
        for i in 0 ..< viewModel.matrix.count where i != draggedColumnIndex {
            viewModel.drag(item: i, bool: false, rowOrColumn: .column)
        }
    }

    // Funktion zum Behandeln von Drag-Gesten für das Verschieben von Zeilen
    func handleDragChangedRow(value: DragGesture.Value, row: Int, size: CGSize) {
        // Zurücksetzen aller Zustände im ViewModel, die mit dem Dragging in Verbindung stehen
        viewModel.varReset()
        viewModel.resetSelection()
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
        viewModel.drag(item: draggedRowIndex, bool: true, rowOrColumn: .row)
        draggedRowIndex = max(0, min(draggedRowIndex, viewModel.matrix.first?.count ?? 0))
        
        // Überprüfen und Durchführen des Zeilenwechsels im ViewModel
        if draggedRowIndex != viewModel.draggedRow {
            withAnimation {
                viewModel.rowSwitch(row1: viewModel.draggedRow ?? row, row2: draggedRowIndex)
            }
            viewModel.draggedRow = draggedRowIndex
        }
        
        // Zurücksetzen des Drag-Zustands für nicht-gezogene Zeilen
        for i in 0 ..< viewModel.matrix.count where i != draggedRowIndex {
            viewModel.drag(item: i, bool: false, rowOrColumn: .row)
        }
    }
    
    // Funktion zum Behandeln des Endes der Drag-Geste
    func handleDragEnded() {
        // Zurücksetzen aller Zustände der Felder, die mit dem Dragging in Verbindung stehen
        viewModel.varReset()
        // Zurücksetzen der gezogenen Spalten- und Zeilenindizes im ViewModel
        viewModel.draggedColumn = nil
        viewModel.draggedRow = nil
    }
}
