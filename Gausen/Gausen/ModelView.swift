//
//  ModelView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.11.23.
//

import Foundation
import SwiftUI

// Definiere eine ViewModel-Klasse
class ViewModel: ObservableObject {
    // Definiere einen Typalias für das Field-Modell
    typealias Field = Model.Field
    typealias Difficulty = Model.Difficulty
    // Instanz des HighscoreManagers, der mit dem ViewModel geteilt wird
    var highScoreManager = HighscoreManager.shared
    
    // Statische Funktion zum Erstellen eines Set-Game-Modells mit einer bestimmten Zeilenanzahl
    private static func createSetGame(rowCount: Int, difficulty : Model.Difficulty ) -> Model {
        Model(rowCount: rowCount, difficulty : difficulty)
    }

    // Eigenschaften, die den Zustand des ViewModels verfolgen
    
    @Published private(set) var time: String = ""
    @Published var draggedColumn: Int?
    @Published var draggedRow: Int?
    @Published var gameStatus: GameStatus = .start
    @Published var playerName: String = ""
    @Published var faktor = 1
    @Published var rowCount = 3
    @Published var difficultyArray : [ Model.Difficulty] = [.easy, .normal, .hard]
    @Published var difficulty : Model.Difficulty = .easy
    @Published private var model: Model = createSetGame(rowCount: 3, difficulty: .easy)
    @Published var selectedRows: [Int] = []
    @Published var selectedColumns: [Int] = []
    @Published var fieldSize: CGSize = .zero
    @Published var gradiendColors: [Color] = [Color.blue, Color.white]
    var positivNegativ = false
    
    // Eigenschaft, die die Anzahl der Aktivitäten im Modell zurückgibt
    var activityCount: Int {
        return model.activityCount
    }
    
    // Eigenschaft, die die Matrix im Modell zurückgibt
    var matrix: [[Field]] {
        return model.matrix
    }
    
    // Eigenschaft, die den aktuellen Knoten in der verketteten Liste im Modell zurückgibt
    var currentNode: LinkedList.Node {
        return model.currentNode
    }

    // Funktion, um den Wert von positivNegativ abzurufen
    func getpositivNegativ() -> Bool {
        return positivNegativ
    }

    // Funktion, um den Wert von positivNegativ zu setzen
    func setpositivNegativ(_ value: Bool) {
        positivNegativ = value
    }
    
    // Funktion zum Aktualisieren der Spielzeit, wenn das Spiel läuft
    func updateTime() {
        if gameStatus == .play {
            time = model.timeTracking()
        }
    }
    
    func valueArray(from value1: Int, to value2: Int) -> [Int] {
        var array: [Int] = []
        for i in value1 ..< value2 + 1 {
            array.append(i)
        }
        return array
    }
    
    // Funktion zum Überprüfen und Aktualisieren des Highscores
    func checkScore() {
        highScoreManager.newScoreActivityCount(activityCount: activityCount, personName: playerName)
        highScoreManager.newScoreTime(time: time, personName: playerName)
    }

    // Funktion zum Zurücksetzen der Auswahl von Zeilen und Spalten
    func resetSelection() {
        selectedRows = []
        selectedColumns = []
    }
    
    // Funktionen zum Umschalten von Zeilen und Spalten im Modell
    func rowSwitch(row1: Int, row2: Int) {
        model.rowSwitch(row1: row1, row2: row2)
    }
    
    func columnSwitch(column1: Int, column2: Int) {
        model.columnSwitch(column1: column1, column2: column2)
    }
    
    // Funktion zum Mischen der Matrix im Modell
    func mixMatrix(howMany: Int, range: Int) {
        model.mixMatrix(howMany: howMany, range: range)
    }

    // Funktionen zum Hinzufügen und Skalieren von Zeilen im Modell
    func addScaleRow(faktor: Int, row1: Int, row2: Int, multi: Bool) {
        model.addScaleRow(faktor: faktor, row1: row1, row2: row2, multi: multi, positivNegativ: positivNegativ)
    }
    
    func scaleRow(faktor: Int, row: Int, multi: Bool) {
        model.scaleRow(faktor: faktor, row: row, multi: multi, positivNegativ: positivNegativ)
    }
    
    // Funktion zur Überprüfung der Skalierung im Modell
    func controllScale(row: Int, faktor: Int, multi: Bool) -> Bool {
        model.controllScale(row: row, faktor: faktor, multi: multi)
    }
    
    // Funktion zum Makieren von gezogenen Zeilen oder Spalten im Modell
    func drag(row: Int = -1, column: Int = -1, bool: Bool) {
        model.drag(row: row, column: column, bool: bool)
    }
    
    // Funktion zum Erstellen einer neuen Matrix mit einer bestimmten Zeilenanzahl
    func newMatrix(rowCount: Int, difficulty : Model.Difficulty) {
        model = ViewModel.createSetGame(rowCount: rowCount, difficulty: difficulty)
        model.generatMatrix()
    }
    
    // Funktion zum Zurücksetzen von Variablen der Fields im Modell
    func varReset() {
        model.varReset()
    }
    
    // Funktionen zum Zurück- und Vorgehen der Matrixen im Modell (undo und redo)
    func back() {
        model.back()
    }
    
    func forwart() {
        model.forwart()
    }
    
    // Funktion zum Aktualisieren der Matrixknoten im Modell
    func updateMatrixNode() {
        model.updateMatrixNode()
    }
    
    // Funktion zum Zurücksetzen des Speichers in der verketteten Liste im Modell
    func resetMemory() {
        model.linkedList.reset()
    }

    // Funktion zum Überprüfen, ob das Spiel gewonnen wurde
    func check() -> Bool {
        model.check()
    }

    // Funktion zum Aktualisieren der Auswahl von Zeilen oder Spalten im Modell
    func updateSelection(item: Int, selection: Bool, axe: String) {
        model.updateSelection(item: item, selection: selection, axe: axe)
    }
    
    func colorSwitch() {
        switch gameStatus {
        case .start:
            gradiendColors = [Color.blue, Color.white]
        case .play:
            gradiendColors = [Color.white, Color.green]
        case .winning:
            gradiendColors = [Color.white, Color.yellow]
        case .highScore:
            gradiendColors = [Color.blue, Color.white]
        }
    }

    // Enum für verschiedene Spielstatus
    enum GameStatus {
        case start, play, winning, highScore
    }
//
//    // enum für Schwirigkeitsgrad
//    enum Difficulty: String {
//        case easy, normal, hard
//
//        // Funktion zur Umwandlung des Enum-Cases in einen String
//        func stringValue() -> String {
//            switch self {
//                    case .easy:
//                        return "Leicht"
//                    case .normal:
//                        return "Normal"
//                    case .hard:
//                        return "Schwer"
//                    }
//        }
//    }
}
