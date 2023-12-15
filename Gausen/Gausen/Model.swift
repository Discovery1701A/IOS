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
    var linkedList : LinkedList
    var currentNode : LinkedList.Node
    init(rowCount: Int) {
        self.linkedList = LinkedList()
        self.currentNode = self.linkedList.emptyNode
        self.rowCount = rowCount
        self.matrix = []
        self.generatMatrix()
        self.linkedList.add(element: self.matrix)
        self.currentNode = linkedList.lastNode
    }
    
    mutating func updateMatrixNode() {
        if let currentNodeMatrix = currentNode.element as? [[Field]] {
            for i in 0 ..< self.matrix.count {
                for j in 0 ..< self.matrix[i].count {
                    if currentNodeMatrix[i][j].content != self.matrix[i][j].content {
                        // Update the element or perform any other actions
                        linkedList.removeAllBehinde(currentNode: currentNode)
                        linkedList.add(element: self.matrix)
                        self.currentNode = linkedList.lastNode
                    }
                }
            }
        }
        if linkedList.numberOfElements > 20 {
            linkedList.remove(index: 0)
        }
    }
    mutating func back () {
        self.currentNode = linkedList.back(currentNode: currentNode)
        self.matrix = self.currentNode.element as! [[Field]]
    }
    
    mutating func forwart () {
        self.currentNode = linkedList.forwart(currentNode: currentNode)
        self.matrix = self.currentNode.element as! [[Field]]
    }
    
    mutating func rowSwitch(row1 : Int, row2 : Int) {
        // print(row1, self.matrix.count)
        if self.matrix[0].count > row1 && row1 >= 0 && self.matrix[0].count > row2 && row2 >= 0 {
            let rowSaver : [Field] = self.matrix[row2]
            self.matrix[row2] = self.matrix[row1]
            self.matrix[row1] = rowSaver
        }
        updateMatrixNode()
    }
    
    mutating func columnSwitch(column1 : Int, column2 : Int) {
        if self.matrix[0].count > column1 && column1 >= 0 && self.matrix[0].count > column2 && column2 >= 0 {
            print(column1, column2)
            for i in 0 ..< self.matrix.count {
                
                let columnSaver : Field = self.matrix[i][column2]
                self.matrix[i][column2] = self.matrix[i][column1]
                self.matrix[i][column1] = columnSaver
            }
        }
        updateMatrixNode()
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
        updateMatrixNode()
    }
    
    mutating func addScaleRow(faktor : Int, row1 : Int, row2 : Int, multi : Bool) {
        if controllScale(row: row1, faktor: faktor, multi : multi) {
            for i in 0 ..< self.matrix[row1].count {
                if multi == true {
                    self.matrix[row2][i].content += self.matrix[row1][i].content * faktor
                    self.matrix[row1][i].notDiv = false
                    //                    print(self.matrix[row2][i].content)
                } else {
                    self.matrix[row2][i].content += self.matrix[row1][i].content / faktor
                    self.matrix[row1][i].notDiv = false
                    //                    print(self.matrix[row2][i].content)
                }
            }
            if faktor == 0 {
                print(0)
            }
        }
        updateMatrixNode()
    }
    
    mutating func controllScale(row : Int, faktor : Int, multi : Bool) -> Bool {
        if faktor != 0 {
            for i in 0 ..< self.matrix[row].count {
                self.matrix[row][i].notDiv = false
                if multi == false {
                    //                        print(self.matrix[row][i].content / faktor, multi)
                    print("ssss", (self.matrix[row][i].content % faktor), self.matrix[row][i].content)
                    if !(self.matrix[row][i].content % faktor == 0) {
                        self.matrix[row][i].notDiv = true
                        //                        print( self.matrix[row][i].notDiv)
                        
                    }
                }
            }
            for j in 0 ..< self.matrix[row].count where self.matrix[row][j].notDiv == true {
                return false
            }
            return true
        }
        return false
    }
    
    mutating func mixMatrix(howMany: Int, range: Int) {
        var addCount = 0
        var switchCount = 0
        
        for _ in 0..<howMany {
            let randomValue = Int.random(in: (-range)..<range)
            let randomRow1 = Int.random(in: 0..<self.matrix.count)
            let randomRow2 = Int.random(in: 0..<self.matrix.count)
            let randomColumn1 = Int.random(in: 0..<self.matrix[0].count)
            let randomColumn2 = Int.random(in: 0..<self.matrix[0].count)
            
            if addCount < howMany / 2 {
                // Zuerst die add-Funktionen aufrufen
                switch Int.random(in: 0..<2) {
                case 0:
                    addScaleRow(faktor: randomValue, row1: randomRow1, row2: randomRow2, multi: Bool.random())
                    addCount += 1
                case 1:
                    scaleRow(faktor: randomValue, row: randomRow1, multi: Bool.random())
                    addCount += 1
                default:
                    break
                }
            } else {
                // Dann die switch-Funktionen aufrufen
                switch Int.random(in: 0..<2) {
                case 0:
                    columnSwitch(column1: randomColumn1, column2: randomColumn2)
                    switchCount += 1
                case 1:
                    rowSwitch(row1: randomRow1, row2: randomRow2)
                    switchCount += 1
                default:
                    break
                }
            }
        }
        varReset()
    }
    
    mutating func vergleichen(is value: Int) -> Bool {
        for i in 0 ..< self.rowCount where self.matrix[i][i].content == value {
            return true
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
        //        for row in matrix {
        // print(row)
        //        }
        // mixMatrix(howMany: 5, range: 3)
    }
    mutating func drag(row : Int = -1, column : Int = -1, bool : Bool) {
        print("drag", row, self.matrix.count)
            if row >= 0 && row < self.matrix.count {
                for i in 0 ..< self.matrix.count {
                    self.matrix[row][i].draged = bool
                    print(self.matrix[row][i].draged)
                }
            }
            if column >= 0 && column < self.matrix[0].count {
                for i in 0 ..< self.matrix.count {
                    self.matrix[i][column].draged = bool
                }
        }
        updateMatrixNode()
    }
    
    mutating func varReset () {
        for i in 0 ..< self.matrix.count {
            for j in 0 ..< self.matrix[i].count where self.matrix[i][j].notDiv == true {
                self.matrix[i][j].notDiv = false
            }
            for j in 0 ..< self.matrix[i].count where self.matrix[i][j].selection == true {
                self.matrix[i][j].selection = false
            }
            for j in 0 ..< self.matrix[i].count where self.matrix[i][j].draged == true {
                print("off")
                self.matrix[i][j].draged = false
            }
        }
        updateMatrixNode()
    }
    
    struct Field :Identifiable, Hashable {
        var content: Int
        let id: Int
        var notDiv = false
        var selection = false
        var draged = false
        init(content: Int, id: Int) {
            self.content = content
            self.id = id
            
        }
    }
}
