//
//  HandelDrag.swift
//  Gausen
//
//  Created by Anna Rieckmann on 24.12.23.
//

import SwiftUI

extension ContentView {
    
    func handleDragChangedColumn(value: DragGesture.Value, column: Int, size: CGSize) {
        modelView.varReset()
        modelView.drag(column: column, bool: true)
        let translation = value.translation.width
        let columnWidth = size.width // CGFloat(modelView.matrix.first?.count ?? 1)
        var draggedColumnIndex = column + Int((value.startLocation.x + translation) / columnWidth)
        
        if Int(value.startLocation.x + translation) < 0 {
            if translation < 0 {
                draggedColumnIndex -= 1
            }
            if translation > 0 {
                draggedColumnIndex += 1
            }
        }
        modelView.drag(column: draggedColumnIndex, bool: true) // Begrenze die Position des gezogenen Rechtecks auf den erlaubten Bereich
        draggedColumnIndex = max(0, min(draggedColumnIndex, modelView.matrix.first?.count ?? 0))
        //        print(column, draggedColumnIndex, Int(value.startLocation.x + translation), value.startLocation.x, modelView.draggedColumn, Int(columnWidth), translation)
        if draggedColumnIndex != modelView.draggedColumn {
            modelView.columnSwitch(column1: modelView.draggedColumn ?? column, column2: draggedColumnIndex)
            modelView.draggedColumn = draggedColumnIndex
            //            modelView.drag( column: column, bool: false)
            //            modelView.varReset()
        }
        for i in 0 ..< modelView.matrix.count where i != draggedColumnIndex {
            modelView.drag(column: i, bool: false)
        }
    }
    
//    func handleScaleGesture(_ scale: CGFloat, row: Int) {
//        // Hier kannst du die Skalierungsfaktor-Logik implementieren
//        let scaleFactor = Double(scale) // Passe dies nach Bedarf an
//        print(scaleFactor)
//        modelView.scaleRow(faktor: Int(scaleFactor), row: row, multi: true)
//    }
    
    func handleDragChangedRow(value: DragGesture.Value, row: Int, size: CGSize) {
        modelView.varReset()
        let translation = value.translation.height
        let rowHeight = size.height // CGFloat(modelView.matrix.first?.count ?? 1)
        var draggedRowIndex = row + Int((value.startLocation.y + translation + CGFloat(row)) / rowHeight)
        
        if Int(value.startLocation.y + translation) < 0 {
            if translation < 0 {
                draggedRowIndex -= 1
//                print(draggedRowIndex, rowHeight, Int(value.startLocation.y + translation))
            }
            if translation > 0 {
                draggedRowIndex += 1
//                print(draggedRowIndex, rowHeight, Int(value.startLocation.y + translation))
            }
        }
        modelView.drag(row: draggedRowIndex, bool: true)
        // Begrenze die Position des gezogenen Rechtecks auf den erlaubten Bereich
        draggedRowIndex = max(0, min(draggedRowIndex, modelView.matrix.first?.count ?? 0))
        
        if draggedRowIndex != modelView.draggedRow {
            modelView.rowSwitch(row1: modelView.draggedRow ?? row, row2: draggedRowIndex)
            modelView.draggedRow = draggedRowIndex
        }
        for i in 0 ..< modelView.matrix.count where i != draggedRowIndex {
            modelView.drag(row: i, bool: false)
        }
    }
    
    func handleDragEnded() {
        modelView.varReset()
        modelView.draggedColumn = nil
        modelView.draggedRow = nil
    }
    
}
