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
    private static func createSetGame () -> Model {
        Model(rowCount: 3)
    }
    @Published private var model: Model = createSetGame()
    // MARK: - Intent(s
    var matrix : [[Field]] {
        return model.matrix
    }
   func rowSwitch(row1 : Int, row2 : Int) {
        model.rowSwitch(row1: row1, row2: row2)
    }
    
    func columnSwitch(column1 : Int, column2 : Int) {
        model.columnSwitch(column1: column1, column2: column2)
    }
    
    func mixMatrix(howMany : Int, range : Int) {
        model.mixMatrix(howMany: howMany, range: range)
    }
    
    func newMatrix() {
        model.generatMatrix()
    }
}
