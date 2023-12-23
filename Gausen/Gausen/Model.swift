//
//  Model.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.11.23.
//

import Foundation

struct Model {
    private(set) var rowCount: Int
    private(set) var matrix: [[Field]]
    var linkedList: LinkedList
    var currentNode: LinkedList.Node
    var activityCount : Int
    var startTime = Date()
    var time : Double = 0.0
    
    init(rowCount: Int) {
        self.linkedList = LinkedList()
        self.currentNode = self.linkedList.emptyNode
        self.rowCount = rowCount
        self.matrix = []
        self.activityCount = 0
        self.generatMatrix()
        self.linkedList.add(element: self.matrix)
        self.currentNode = self.linkedList.lastNode
    }
    
    mutating func timeTracking() -> String {
      
               let timeNow = Date()
               time = timeNow.timeIntervalSince(startTime)
               let formatter = DateComponentsFormatter()
                   formatter.unitsStyle = .positional
                   formatter.allowedUnits = [.minute, .second]
                   formatter.zeroFormattingBehavior = .pad
       //        time = formatter.string(from: elapsedTime)!
//        print(formatter.string(from: time))
        return formatter.string(from: time) ?? "00"
           }
    
    mutating func updateMatrixNode() {
        if let currentNodeMatrix = currentNode.element as? [[Field]] {
            for i in 0 ..< self.matrix.count where i < currentNodeMatrix.count {
                for j in 0 ..< self.matrix[i].count where j < currentNodeMatrix[i].count {
                    if currentNodeMatrix[i][j].content != self.matrix[i][j].content {
                        // Update the element or perform any other actions
                        self.linkedList.removeAllBehinde(currentNode: self.currentNode)
                       
                        self.varReset()
                        self.linkedList.add(element: self.matrix)
                        self.currentNode = self.linkedList.lastNode
                        
                        if self.linkedList.numberOfElements > 20 {
                            self.linkedList.remove(index: 0)
                        }
                        return
                    }
                }
            }
        }
    }

    mutating func back() {
        if self.linkedList.back(currentNode: self.currentNode).element != nil {
            self.currentNode = self.linkedList.back(currentNode: self.currentNode)
            self.matrix = self.currentNode.element as! [[Field]]
        }
    }
    
    mutating func forwart() {
        if self.linkedList.forwart(currentNode: self.currentNode).element != nil {
            self.currentNode = self.linkedList.forwart(currentNode: self.currentNode)
            self.matrix = self.currentNode.element as! [[Field]]
        }
    }
    
    mutating func rowSwitch(row1: Int, row2: Int) {
        // print(row1, self.matrix.count)
        if self.matrix[0].count > row1, row1 >= 0, self.matrix[0].count > row2, row2 >= 0 {
            let rowSaver: [Field] = self.matrix[row2]
            self.matrix[row2] = self.matrix[row1]
            self.matrix[row1] = rowSaver
        }
        self.activityCount += 1
        self.updateMatrixNode()
    }
    
    mutating func columnSwitch(column1: Int, column2: Int) {
        if self.matrix[0].count > column1, column1 >= 0, self.matrix[0].count > column2, column2 >= 0 {
            print(column1, column2)
            for i in 0 ..< self.matrix.count {
                let columnSaver: Field = self.matrix[i][column2]
                self.matrix[i][column2] = self.matrix[i][column1]
                self.matrix[i][column1] = columnSaver
            }
        }
        self.activityCount += 1
        self.updateMatrixNode()
    }
    
    mutating func scaleRow(faktor: Int, row: Int, multi: Bool) {
        print(self.controllScale(row: row, faktor: faktor, multi: multi))
        if self.controllScale(row: row, faktor: faktor, multi: multi) {
            for i in 0 ..< self.matrix[row].count {
                if multi == true {
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
        self.activityCount += 1
        self.updateMatrixNode()
    }
    
    mutating func addScaleRow(faktor: Int, row1: Int, row2: Int, multi: Bool) {
        if self.controllScale(row: row1, faktor: faktor, multi: multi) {
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
        self.activityCount += 1
        self.updateMatrixNode()
    }
    
    mutating func controllScale(row: Int, faktor: Int, multi: Bool) -> Bool {
        if faktor != 0 {
            for i in 0 ..< self.matrix[row].count {
                self.matrix[row][i].notDiv = false
                if multi == false {
                    // print("ssss", self.matrix[row][i].content % faktor, self.matrix[row][i].content)
                    if !(self.matrix[row][i].content.isMultiple(of: faktor)) {
                        self.matrix[row][i].notDiv = true
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
//        let randomRow1 = Int.random(in: 0 ..< self.matrix.count)
//        let randomRow2 = Int.random(in: 0 ..< self.matrix.count)
//        let randomColumn1 = Int.random(in: 0 ..< self.matrix[0].count)
//        let randomColumn2 = Int.random(in: 0 ..< self.matrix[0].count)
        for _ in 0 ..< howMany {
            for i in 0 ..< self.matrix.count {
                let randomValue = Int.random(in: -range ..< range)
//                let randomValue2 = Int.random(in: -range ..< range)
                var randomRow2 = Int.random(in: 0 ..< self.matrix.count)
                var randomBool = Bool.random()
                if !self.controllScale(row: i, faktor: randomValue, multi: randomBool) {
                    randomBool.toggle()
                }
                if i == randomRow2 {
                    randomRow2 = Int.random(in: 0 ..< self.matrix.count)
                }
                self.scaleRow(faktor: randomValue, row: i, multi: randomBool)
                self.addScaleRow(faktor: 1, row1: i, row2: randomRow2, multi: randomBool)
            }
            for i in 0 ..< self.matrix.count {
                var randomRow2 = Int.random(in: 0 ..< self.matrix.count)
                var randomColumn2 = Int.random(in: 0 ..< self.matrix[0].count)
                if i == randomRow2 {
                    randomRow2 = Int.random(in: 0 ..< self.matrix.count)
                }
                if i == randomColumn2 {
                    randomColumn2 = Int.random(in: 0 ..< self.matrix.count)
                }
                self.rowSwitch(row1: i, row2: randomRow2)
                self.columnSwitch(column1: i, column2: randomColumn2)
            }
        }
        self.linkedList.reset()
        self.activityCount = 0
        self.varReset()
    }
    
    mutating func vergleichen(is value: Int) -> Bool {
        for i in 0 ..< self.rowCount where self.matrix[i][i].content == value {
            return true
        }
        return false
    }
    
    mutating func generatMatrix() {
        self.matrix = []
        var id = 0
        if self.matrix.count < self.rowCount {
            for i in 0 ..< self.rowCount {
                self.matrix.append([])
                for j in 0 ..< self.rowCount {
                    id += 1
                    if j == i {
                        self.matrix[i].append(Field(content: 1, id: id))
                    } else {
                        self.matrix[i].append(Field(content: 0, id: id))
                    }
                }
            }
        }
        startTime = Date()
        //        for row in matrix {
        // print(row)
        //        }
        // mixMatrix(howMany: 5, range: 3)
    }

    mutating func drag(row: Int = -1, column: Int = -1, bool: Bool) {
        print("drag", row, self.matrix.count)
        if row >= 0, row < self.matrix.count {
            for i in 0 ..< self.matrix.count {
                self.matrix[row][i].draged = bool
                print(self.matrix[row][i].draged)
            }
        }
        if column >= 0, column < self.matrix[0].count {
            for i in 0 ..< self.matrix.count {
                self.matrix[i][column].draged = bool
            }
        }
        self.updateMatrixNode()
    }
    
    mutating func varReset() {
        print(self.matrix.count)
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
    }
    
    mutating func updateSelection(item: Int, selection: Bool, axe: String) {
        guard item >= 0, item < self.matrix.count else {
            return
        }
        for i in 0 ..< self.matrix.count {
            if axe == "row" {
                self.matrix[item][i].selection = selection
            }
            if axe == "column" {
                self.matrix[i][item].selection = selection
            }
        }
    }
    
    func isConvertibleToIdentity(matrix: [[Field]]) -> Bool {
        let rowCount = matrix.count
        let columnCount = matrix[0].count

        // Überprüfe, ob die Matrix quadratisch ist
        guard rowCount == columnCount else {
            return false
        }

        // Berechne den Rang der Matrix
        let rank = self.calculateRank(matrix: matrix)

        // Überprüfe, ob der Rang gleich der Anzahl der Zeilen/Spalten ist
        return rank == rowCount
    }

    func calculateRank(matrix: [[Field]]) -> Int {
        var augmentedMatrix = matrix
        let rowCount = matrix.count
        let columnCount = matrix[0].count

        var rank = 0

        for col in 0 ..< columnCount {
            var foundPivot = false

            // Suche nach einem nicht-null Element in der aktuellen Spalte
            for row in rank ..< rowCount {
                if augmentedMatrix[row][col].content != 0 {
                    // Tausche die Zeilen aus, um ein Nicht-Null-Element als Pivot zu erhalten
                    augmentedMatrix.swapAt(rank, row)
                    foundPivot = true
                    break
                }
            }

            // Wenn kein Pivot gefunden wurde, gehe zur nächsten Spalte
            if !foundPivot {
                continue
            }

            // Setze alle Elemente über und unter dem Pivot auf null
            let pivot = augmentedMatrix[rank][col].content
            for i in 0 ..< rowCount {
                if i != rank {
                    let factor = -augmentedMatrix[i][col].content / pivot
                    for j in 0 ..< columnCount {
                        augmentedMatrix[i][j].content += factor * augmentedMatrix[rank][j].content
                    }
                }
            }

            // Inkrementiere den Rang
            rank += 1
        }

        return rank
    }
    
    struct Field: Identifiable, Hashable {
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
