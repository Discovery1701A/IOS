//
//  Model.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.11.23.
//

import Foundation

struct Model {
    private(set) var rowCount : Int
    private(set) var matrix : [[Field]]
    init(rowCount: Int) {
        self.rowCount = rowCount
        self.matrix = []
        generatMatrix()
    }
    
    mutating func generatMatrix() {
        self.matrix = []
       var id : Int = 0
        for i in 0 ..< self.rowCount {
            self.matrix.append([])
            for j in 0 ..< self.rowCount {
                id += 1
                if j == i {
                    self.matrix[i].append(Field(content: 1, id: id ))
                } else {
                        self.matrix[i].append(Field(content: 0, id: id ))
                }
                
            }
        }
        for row in matrix {
            print(row)
        }
    }
    
    struct Field :Identifiable, Hashable {
        let content: Int
        let id : Int
        init(content: Int, id: Int) {
                self.content = content
                self.id = id
            }
    }
}
