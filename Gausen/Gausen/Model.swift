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
    
    mutating func rowSwitch(row1 : Int, row2 : Int) {
       // print(row1, self.matrix.count)
        if row1 < self.matrix.count && row2 < self.matrix.count {
            let rowSaver : [Field] = self.matrix[row2]
            self.matrix[row2] = self.matrix[row1]
            self.matrix[row1] = rowSaver
        }
    }
    
    mutating func columnSwitch(column1 : Int, column2 : Int) {
        if column1 >= 0 && column2 >= 0 {
            for i in 0 ..< self.matrix.count {
                let columnSaver : Field = self.matrix[i][column2]
                self.matrix[i][column2] = self.matrix[i][column1]
                self.matrix[i][column1] = columnSaver
            }
        }
    }
    
    mutating func scaleRow(faktor : Int, row : Int, multi : Bool) {
        if controllScale(row: row, faktor: faktor, multi : multi) {
            for i in 0 ..< self.matrix[row].count {
                if multi == true || faktor < 0 {
                    self.matrix[row][i].content *= faktor
                    print(self.matrix[row][i].content)
                } else {
                    self.matrix[row][i].content /= faktor
                    print(self.matrix[row][i].content)
                }
            }
            if faktor == 0 {
                print(0)
            }
        }
    }
   
    mutating func addScaleRow(faktor : Int, row1 : Int, row2 : Int, multi : Bool) {
        if controllScale(row: row1, faktor: faktor, multi : multi) {
            for i in 0 ..< self.matrix[row1].count {
                if multi == true || faktor <= 0 {
                    self.matrix[row2][i].content += self.matrix[row1][i].content * faktor
//                    print(self.matrix[row2][i].content)
                } else {
                    self.matrix[row2][i].content += self.matrix[row1][i].content / faktor
//                    print(self.matrix[row2][i].content)
                }
        }
            if faktor == 0 {
                print(0)
            }
    }
}

    func controllScale(row : Int, faktor : Int, multi : Bool) -> Bool {
        if faktor != 0 {
            for i in 0 ..< self.matrix[row].count {
                
                if multi == true || faktor <= 0 {
                    if !(type(of: self.matrix[row][i].content * faktor) == Int.self) {
                        return false
                    }
                } else {
//                    print(self.matrix[row][i].content / faktor, multi)
                    if !(type(of: self.matrix[row][i].content / faktor) == Int.self) {
                        
                        return false
                    }
                }
            }
            return true
        }
        return false
    }
   
    mutating func mixMatrix(howMany : Int, range : Int) {
        
        for i in 0 ..< howMany {
                    
                    if Bool.random() == true {
                        addScaleRow(faktor: Int.random(in: (-range)..<(range - 1)), row1: Int.random(in: 0..<self.matrix.count), row2: Int.random(in: 0..<self.matrix.count), multi: Bool.random())
//                        print(i)
                      //  continue
                    } else if Bool.random() == true {
                            scaleRow(faktor : Int.random(in: (-range)..<(range - 1)), row : Int.random(in: 0..<self.matrix.count), multi: Bool.random())
                            //  continue
                        
                    } else if Bool.random() == true {
                        
                        columnSwitch(column1: Int.random(in: 0..<self.matrix.count), column2:Int.random(in: 0..<self.matrix.count))
                      //  continue
                    } else {
                        rowSwitch(row1: Int.random(in: 0..<self.matrix.count), row2: Int.random(in: 0..<self.matrix.count))
                    }
            
        }
    }
    mutating func vergleichen(is value : Int) -> Bool {
        for i in 0 ..< self.rowCount {
            for j in 0 ..< self.rowCount {
                if self.matrix[i][j].content == value {
                    return true
                }
            }
        }
        return false
    }
   
    mutating func generatMatrix() {
        self.matrix = []
        var id : Int = 0
        if self.matrix.count < rowCount {
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
        }
        for row in matrix {
           // print(row)
        }
       // mixMatrix(howMany: 5, range: 3)
    }
    
    struct Field :Identifiable, Hashable {
        var content: Int
        let id : Int
        init(content: Int, id: Int) {
            self.content = content
            self.id = id
        }
    }
}
