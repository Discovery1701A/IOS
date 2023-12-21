//
//  ModelView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.11.23.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    typealias Field = Model.Field
    
    var testMatrix = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
    ]
    private static func createSetGame(rowCount: Int) -> Model {
        Model(rowCount: rowCount)
    }

    @Published private var model: Model = createSetGame(rowCount: 2)
    @Published var draggedColumn: Int?
    @Published var draggedRow: Int?
    @Published var status: String = "start"
    @Published  var faktor = 1.0
        @Published  var rowCount = 3.0
        @Published  var isEditing = false
        @Published  var selectedRows: [Int] = []
        @Published  var selectedColumns: [Int] = []
        @Published var fieldSize: CGSize = .zero
    var matrix: [[Field]] {
        return model.matrix
    }
    // Getter-Methoden für die einzelnen Eigenschaften
        func getFaktor() -> Double {
            return faktor
        }

        func getRowCount() -> Double {
            return rowCount
        }

        func getIsEditing() -> Bool {
            return isEditing
        }

        func getSelectedRows() -> [Int] {
            return selectedRows
        }

        func getSelectedColumns() -> [Int] {
            return selectedColumns
        }

        func getFieldSize() -> CGSize {
            return fieldSize
        }

        // Setter-Methoden für die einzelnen Eigenschaften
        func setFaktor(_ value: Double) {
            faktor = value
        }

        func setRowCount(_ value: Double) {
            rowCount = value
        }

        func setIsEditing(_ value: Bool) {
            isEditing = value
        }

        func setSelectedRows(_ value: [Int]) {
            selectedRows = value
        }

        func setSelectedColumns(_ value: [Int]) {
            selectedColumns = value
        }

        func setFieldSize(_ value: CGSize) {
            fieldSize = value
        }

    func rowSwitch(row1: Int, row2: Int) {
        model.rowSwitch(row1: row1, row2: row2)
    }
    
    func columnSwitch(column1: Int, column2: Int) {
        model.columnSwitch(column1: column1, column2: column2)
    }
    
    func mixMatrix(howMany: Int, range: Int) {
        model.mixMatrix(howMany: howMany, range: range)
    }

    func addScaleRow(faktor: Int, row1: Int, row2: Int, multi: Bool) {
        model.addScaleRow(faktor: faktor, row1: row1, row2: row2, multi: multi)
    }
    
    func scaleRow(faktor: Int, row: Int, multi: Bool) {
        model.scaleRow(faktor: faktor, row: row, multi: multi)
    }
    
    func controllScale(row: Int, faktor: Int, multi: Bool) -> Bool {
        model.controllScale(row: row, faktor: faktor, multi: multi)
    }
    
    func drag(row: Int = -1, column: Int = -1, bool: Bool) {
        model.drag(row: row, column: column, bool: bool)
    }
    
    func newMatrix(rowCount: Int) {
        model = ViewModel.createSetGame(rowCount: rowCount)
        model.generatMatrix()
    }
    
    func varReset() {
        model.varReset()
    }
    
    func back() {
        model.back()
    }
    
    func forwart() {
        model.forwart()
    }
    
    func updateMatrixNode() {
        model.updateMatrixNode()
    }
    
    func resetMemory() {
        model.linkedList.reset()
    }
    
    func updateSelection(item: Int, selection: Bool, axe: String) {
//        DispatchQueue.main.async {
            self.model.updateSelection(item: item, selection: selection, axe: axe)
        }
//    }

}
