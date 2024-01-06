//
//  Model.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.11.23.
//
// Modellstruktur für das Gausen-Spiel

import Foundation

struct Model {
    // Struktur für ein Feld im Spiel
    struct Field: Identifiable, Hashable {
        var content: Int // Der Inhalt des Feldes
        let id: Int // Eindeutige Identifikationsnummer des Feldes
        // Hauptsächlich zum markiren
        var notDiv = false // Gibt an, ob der Inhalt nicht durch den Faktor teilbar ist
        var selection = false // Gibt an, ob das Feld ausgewählt ist
        var draged = false // Gibt an, ob das Feld gezogen wird
        var winning = false // Gibt an, ob das Feld Teil der Einsen ist

        init(content: Int, id: Int) {
            self.content = content
            self.id = id
        }
    }

    // Eigenschaften des Modells
    private(set) var rowCount: Int // Anzahl der Zeilen in der Matrix
    private(set) var matrix: [[Field]] // Die Hauptspielmatrix
    private(set) var unitMatrix: [[Field]] // Die Einheitsmatrix für den Vergleich mit dem Spielergebnis
    var linkedList: LinkedList // Verkettete Liste zum Speichern der Zustandsänderungen des Spiels
    var currentNode: LinkedList.Node // Aktueller Knoten in der verketteten Liste
    var activityCount: Int // Anzahl der Aktionen/Schritte des Spielers
    var startTime = Date() // Startzeit des aktuellen Spiels
    var time: Double // Gespielte Zeit seit dem Start
    var difficulty: Difficulty

    // Initialisierung des Modells mit einer bestimmten Anzahl von Zeilen
    init(rowCount: Int, difficulty: Difficulty) {
        self.linkedList = LinkedList() // Initialisierung der verketteten Liste
        self.currentNode = self.linkedList.emptyNode // Der aktuelle Knoten wird auf den leeren Knoten gesetzt
        self.difficulty = difficulty
        self.rowCount = rowCount // Festlegen der Anzahl der Zeilen
        self.matrix = [] // Initialisierung der Hauptspielmatrix
        self.unitMatrix = [] // Initialisierung der Einheitsmatrix
        self.time = 0.0 // Initialisierung der Spielzeit
        self.activityCount = 0 // Initialisierung der Aktionsanzahl
        self.generateMatrix() // Generierung der Anfangsmatrix
        self.linkedList.add(element: self.matrix) // Hinzufügen der Matrix zum Anfang der verketteten Liste
        self.currentNode = self.linkedList.lastNode // Der aktuelle Knoten wird auf den letzten Knoten gesetzt
    }

    // Funktion zur Verfolgung der vergangenen Spielzeit als formatierten String
    mutating func timeTracking() -> String {
        // Aktuelle Zeit abrufen
        let timeNow = Date()
        // Berechne die vergangene Spielzeit
        self.time = timeNow.timeIntervalSince(self.startTime)

        // Formatter für die Darstellung der Spielzeit
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad

        // Rückgabe der formatierten Spielzeit
        return formatter.string(from: self.time) ?? "00"
    }

    // Funktion zum Aktualisieren des aktuellen Matrixknotens bei Änderungen
    mutating func updateMatrixNode() {
        // Überprüfen, ob der aktuelle Matrixknoten gültig ist
        if let currentNodeMatrix = currentNode.element as? [[Field]] {
            // Iteration über die Zeilen der Matrix
            for i in 0 ..< self.matrix.count where i < currentNodeMatrix.count {
                // Iteration über die Spalten der Matrix
                for j in 0 ..< self.matrix[i].count where j < currentNodeMatrix[i].count {
                    // Überprüfen, ob der Inhalt des Feldes unterschiedlich ist
                    if currentNodeMatrix[i][j].content != self.matrix[i][j].content {
                        // Wenn unterschiedlich, lösche den Verlauf ab diesem Punkt  in die Richtung->
                        self.linkedList.removeAllBehind(currentNode: self.currentNode)
                        // Setze Makierungen zurück und speichere den aktuellen Zustand erneut
                        self.varReset()
                        self.linkedList.add(element: self.matrix)
                        self.currentNode = self.linkedList.lastNode
                        // Wenn die Anzahl der gespeicherten Zustände mehr als 20 beträgt, entferne den ältesten Zustand
                        if self.linkedList.numberOfElements > 20 {
                            self.linkedList.remove(index: 0)
                        }
                        return
                    }
                }
            }
        }
    }

    // Funktion zum Zurückgehen zu einem vorherigen Zustand in der verketteten Liste (undo)
    mutating func back() {
        // Überprüfen, ob es einen vorherigen Zustand gibt
        if self.linkedList.back(currentNode: self.currentNode).element != nil {
            // Aktualisiere den aktuellen Knoten und die Matrix
            self.currentNode = self.linkedList.back(currentNode: self.currentNode)
            self.matrix = self.currentNode.element as! [[Field]]
        }
    }

    // Funktion zum Vorwärtsgehen zu einem nachfolgenden Zustand in der verketteten Liste (redo)
    mutating func forward() {
        // Überprüfen, ob es einen nachfolgenden Zustand gibt
        if self.linkedList.forward(currentNode: self.currentNode).element != nil {
            // Aktualisiere den aktuellen Knoten und die Matrix
            self.currentNode = self.linkedList.forward(currentNode: self.currentNode)
            self.matrix = self.currentNode.element as! [[Field]]
        }
    }

    // Funktion zum Vertauschen von zwei Zeilen in der Matrix
    mutating func rowSwitch(row1: Int, row2: Int) {
        // Überprüfen, ob die übergebenen Zeilenindizes gültig sind
        if self.matrix[0].count > row1, row1 >= 0, self.matrix[0].count > row2, row2 >= 0 {
            // Vertausche die Zeilen
            let rowSaver: [Field] = self.matrix[row2]
            self.matrix[row2] = self.matrix[row1]
            self.matrix[row1] = rowSaver
        }
        // Inkrementiere die Aktivitätszählung und aktualisiere den Matrixknoten
        self.activityCount += 1
        self.updateMatrixNode()
    }

    // Funktion zum Vertauschen von zwei Spalten in der Matrix
    mutating func columnSwitch(column1: Int, column2: Int) {
        // Überprüfen, ob die übergebenen Spaltenindizes gültig sind
        if self.matrix[0].count > column1, column1 >= 0, self.matrix[0].count > column2, column2 >= 0 {
            // Vertausche die Spalten
            for i in 0 ..< self.matrix.count {
                let columnSaver: Field = self.matrix[i][column2]
                self.matrix[i][column2] = self.matrix[i][column1]
                self.matrix[i][column1] = columnSaver
            }
        }
        // Inkrementiere die Aktivitätszählung und aktualisiere den Matrixknoten
        self.activityCount += 1
        self.updateMatrixNode()
    }

    // Funktion zum Skalieren einer Zeile in der Matrix
    mutating func scaleRow(faktor: Int, row: Int, divOrMulti: DivOrMulti, positivNegativ: Bool) {
        // Überprüfen, ob die Skalierung gültig ist
        if self.controlScale(row: row, faktor: faktor, divOrMulti: divOrMulti) {
            // Skaliere die Zeile
            for i in 0 ..< self.matrix[row].count {
                if positivNegativ {
                    self.matrix[row][i].content *= -1
                }
                if divOrMulti == .multiply {
                    self.matrix[row][i].content *= faktor
                } else {
                    self.matrix[row][i].content /= faktor
                }
            }
        }
        // Inkrementiere die Aktivitätszählung und aktualisiere den Matrixknoten
        self.activityCount += 1
        self.updateMatrixNode()
    }

    // Funktion zum Hinzufügen und Skalieren einer Zeile zu einer anderen in der Matrix
    mutating func addScaledRow(faktor: Int, row1: Int, row2: Int, divOrMulti: DivOrMulti, positivNegativ: Bool) {
        // Überprüfen, ob die Skalierung gültig ist
        if self.controlScale(row: row1, faktor: faktor, divOrMulti: divOrMulti) {
            // Hinzufügen und Skalieren der Zeile zu einer anderen
            var rowSaver: [Int] = []
            for i in 0 ..< self.matrix[row1].count {
                if divOrMulti == .multiply {
                    rowSaver.append(self.matrix[row1][i].content * faktor)
                    self.matrix[row1][i].notDiv = false
                } else {
                    rowSaver.append(self.matrix[row1][i].content / faktor)
                    self.matrix[row1][i].notDiv = false
                }
                if positivNegativ {
                    self.matrix[row2][i].content -= rowSaver[i]
                } else {
                    self.matrix[row2][i].content += rowSaver[i]
                }
            }
        }
        // Inkrementiere die Aktivitätszählung und aktualisiere den Matrixknoten
        self.activityCount += 1
        self.updateMatrixNode()
    }

    // Funktion zur Überprüfung, ob eine Skalierung in einer Zeile gültig ist
    mutating func controlScale(row: Int, faktor: Int, divOrMulti: DivOrMulti) -> Bool {
        // Überprüfen, ob der Faktor nicht 0 ist
        if faktor != 0 {
            // Überprüfen, ob die Skalierung in jedem Element der Zeile gültig ist
            for i in 0 ..< self.matrix[row].count {
                self.matrix[row][i].notDiv = false
                if divOrMulti == .divide {
                    if !(self.matrix[row][i].content.isMultiple(of: faktor)) {
                        self.matrix[row][i].notDiv = true
                    }
                }
            }
            // Überprüfen, ob es ein Element mit notDiv = true gibt
            for j in 0 ..< self.matrix[row].count where self.matrix[row][j].notDiv == true {
                return false
            }
            // Rückgabe, dass die Skalierung gültig ist
            return true
        }
        // Rückgabe, dass die Skalierung ungültig ist (Faktor ist 0)
        return false
    }

    // Funktion zur Generierung der Einheitsmatrix
    mutating func generateMatrix() {
        // Initialisiere eine leere Matrix und eine ID
        var generatedMatrix: [[Field]] = []
        var id = 0

        // Erstelle die Einheitsmatrix, wenn sie noch nicht erstellt wurde
        if generatedMatrix.count < self.rowCount {
            for i in 0 ..< self.rowCount {
                generatedMatrix.append([])
                for j in 0 ..< self.rowCount {
                    id += 1
                    // Setze 1 auf der Hauptdiagonale, sonst 0
                    if j == i {
                        generatedMatrix[i].append(Field(content: 1, id: id))
                    } else {
                        generatedMatrix[i].append(Field(content: 0, id: id))
                    }
                }
            }
        }

        // Setze die Matrix, die Einheitsmatrix und mischt die Spielmatrix
        self.matrix = generatedMatrix
        self.unitMatrix = generatedMatrix
        self.startTime = Date()
        switch self.difficulty {
        case .easy:
            self.mixMatrix(howMany: 1, range: 10)
        case .normal:
            self.mixMatrix(howMany: 2, range: 10)
        case .hard:
            self.mixMatrix(howMany: 4, range: 10)
        }
    }

    // Funktion zum Markieren der gewonnenen Kombination in der Matrix
    mutating func markWinnig() {
        // Markiere die Einsen als gewonnen
        for i in 0 ..< self.matrix.count {
            self.matrix[i][i].winning = true
        }
    }

    // Funktion zum Mischen der Matrix
    mutating func mixMatrix(howMany: Int, range: Int) {
        // Iteration über die Anzahl der Mischvorgänge
        for _ in 0 ..< howMany {
            // Iteration über jede Zeile der Matrix
            for i in 0 ..< self.matrix.count {
                // Zufällige Werte für den Mischvorgang
                let randomValue = Int.random(in: 1 ..< range)
                var randomRow2 = Int.random(in: 0 ..< self.matrix.count)
                let randomPositivNegativ = Bool.random()
                var randomDivOrMulti: DivOrMulti = Bool.random() ? .multiply : .divide

                // Überprüfen, ob die Skalierung gültig ist, andernfalls den Multiplikator umkehren
                if !self.controlScale(row: i, faktor: randomValue, divOrMulti: randomDivOrMulti) {
                    randomDivOrMulti = .multiply
                }
                // Überprüfen, dass die Zeilenindizes unterschiedlich sind
                if i == randomRow2 {
                    randomRow2 = Int.random(in: 0 ..< self.matrix.count)
                }

                // Skaliere die aktuelle Zeile und füge sie zu einer anderen Zeile hinzu
                self.scaleRow(faktor: randomValue, row: i, divOrMulti: randomDivOrMulti, positivNegativ: randomPositivNegativ)
                if randomRow2 != i {
                    self.addScaledRow(faktor: 1, row1: i, row2: randomRow2, divOrMulti: randomDivOrMulti, positivNegativ: randomPositivNegativ)
                }
            }

            // Iteration über jede Zeile der Matrix
            for i in 0 ..< self.matrix.count {
                var randomRow2 = Int.random(in: 0 ..< self.matrix.count)
                var randomColumn2 = Int.random(in: 0 ..< self.matrix[0].count)

                // Überprüfen, dass die Zeilen- und Spaltenindizes unterschiedlich sind
                if i == randomRow2 {
                    randomRow2 = Int.random(in: 0 ..< self.matrix.count)
                }

                if i == randomColumn2 {
                    randomColumn2 = Int.random(in: 0 ..< self.matrix.count)
                }

                // Vertausche zwei Zeilen und zwei Spalten
                self.rowSwitch(row1: i, row2: randomRow2)
                self.columnSwitch(column1: i, column2: randomColumn2)
            }
        }

        // Zurücksetzen des Verlaufs und des Zustands
        self.linkedList.reset()
        self.linkedList.add(element: self.matrix)
        self.currentNode = self.linkedList.lastNode
        self.activityCount = 0
        self.varReset()
    }

    // Funktion zum Überprüfen, ob das Spiel gewonnen wurde
    mutating func check() -> Bool {
        // Iteration über die Einheitsmatrix, um zu überprüfen, ob die Matrix gewonnen wurde
        for i in 0 ..< self.unitMatrix.count {
            for j in 0 ..< self.unitMatrix.count where self.unitMatrix[i][j].content != self.matrix[i][j].content {
                // Rückgabe, dass das Spiel nicht gewonnen wurde
                return false
            }
        }
        // Markiere die gewonnene Kombination und Rückgabe, dass das Spiel gewonnen wurde
        self.markWinnig()
        return true
    }

    // Funktion zum Aktivieren/Deaktivieren des "Drag"-Zustands für eine Zeile oder Spalte
    mutating func drag(item: Int, bool: Bool, rowOrColumn: RowOrColumn) {
        // Aktiviere/Deaktiviere "Draged"-Zustand für eine Zeile oder Spalte
        if item >= 0, item < self.matrix.count {
            for i in 0 ..< self.matrix.count {
                switch rowOrColumn {
                case .row:
                    self.matrix[item][i].draged = bool
                case .column:
                    self.matrix[i][item].draged = bool
                }
            }
        }
        // Aktualisiere den Matrixknoten
        self.updateMatrixNode()
    }

    // Funktion zum Aktualisieren des "selection"-Zustands für eine Zeile oder Spalte
    mutating func updateSelection(item: Int, selection: Bool, rowOrColumn: RowOrColumn) {
        guard item >= 0, item < self.matrix.count else {
            return
        }
        for i in 0 ..< self.matrix.count {
            // Aktualisiere den "selection"-Zustand für eine Zeile oder Spalten
            switch rowOrColumn {
            case .row:
                self.matrix[item][i].selection = selection
            case .column:
                self.matrix[i][item].selection = selection
            }
        }
    }

    // Funktion zum Zurücksetzen verschiedener Zustände in der Matrix
    mutating func varReset() {
//        print(self.matrix.count)
        for i in 0 ..< self.matrix.count {
            // Setze den "notDiv"-Zustand auf "false" für alle Felder
            for j in 0 ..< self.matrix[i].count where self.matrix[i][j].notDiv == true {
                self.matrix[i][j].notDiv = false
            }
            // Setze den "selection"-Zustand auf "false" für alle Felder
            for j in 0 ..< self.matrix[i].count where self.matrix[i][j].selection == true {
                self.matrix[i][j].selection = false
            }
            // Setze den "draged"-Zustand auf "false" für alle Felder
            for j in 0 ..< self.matrix[i].count where self.matrix[i][j].draged == true {
                self.matrix[i][j].draged = false
            }
        }
    }

    // enum für Schwirigkeitsgrad
    enum Difficulty: String {
        case easy, normal, hard

        // Funktion zur Umwandlung des Enum-Cases in einen String
        func stringValue() -> String {
            switch self {
            case .easy:
                return "Leicht"
            case .normal:
                return "Normal"
            case .hard:
                return "Schwer"
            }
        }
    }

    // enum für Reihe oder Spalte
    enum RowOrColumn {
        case row, column
    }

    enum DivOrMulti: String {
        case multiply, divide

        func stringValue() -> String {
            return self.rawValue
        }
    }
}
