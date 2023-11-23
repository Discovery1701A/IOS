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
    var testMatrix = [[1,2,3],
                      [4,5,6],
                      [7,8,9]]
    private static func createSetGame () -> Model {
        Model(rowCount: 3) 
    }
    @Published private var model: Model = createSetGame()
    // MARK: -Intent(s
    var matrix : [[Field]] {
       return model.matrix
    }
}
