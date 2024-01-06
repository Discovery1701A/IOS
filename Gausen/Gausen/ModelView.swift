//
//  ModelView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.11.23.
//
// Definiere eine ViewModel-Klasse

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    // Definiere Typalias
    typealias Field = Model.Field
    typealias Difficulty = Model.Difficulty
    typealias DivOrMulti = Model.DivOrMulti
    
    // Instanz des HighscoreManagers, der mit dem ViewModel geteilt wird
    var highScoreManager = HighscoreManager.shared
    
    // Statische Funktion zum Erstellen eines Set-Game-Modells mit einer bestimmten Zeilenanzahl
    private static func createSetGame(rowCount: Int, difficulty: Model.Difficulty) -> Model {
        Model(rowCount: rowCount, difficulty: difficulty)
    }

    // Eigenschaften, die den Zustand des ViewModels verfolgen
    @Published private(set) var time: String = ""
    @Published var draggedColumn: Int?
    @Published var draggedRow: Int?
    @Published var gameStatus: GameStatus = .start
    @Published var playerName: String = ""
    @Published var factor: Int = 1
    @Published var rowCount: Int = 3
    @Published var difficultyArray: [Model.Difficulty] = [.easy, .normal, .hard]
    @Published var difficulty: Model.Difficulty = .normal
    @Published private var model: Model = createSetGame(rowCount: 3, difficulty: .easy)
    @Published var selectedRows: [Int] = []
    @Published var selectedColumns: [Int] = []
    @Published var fieldSize: CGSize = .zero
    @Published var gradientColors: [Color] = [Color.cyan, Color.white]
    @Published var parentSize: CGSize = .zero // die Größe des Elternelements 
    var blurRadius: CGFloat = 5
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
    func getPositivNegativ() -> Bool {
        return positivNegativ
    }

    // Funktion, um den Wert von positivNegativ zu setzen
    func setPositivNegativ(_ value: Bool) {
        positivNegativ = value
    }
    
    // Funktion zum Aktualisieren der Spielzeit, wenn das Spiel läuft
    func updateTime() {
        if gameStatus == .play {
            time = model.timeTracking()
        }
    }
    
    // Funktion zum Erstellen eines Arrays
    func valueArray(from value1: Int, to value2: Int) -> [Int] {
        var array: [Int] = []
        for i in value1 ..< value2 + 1 {
            array.append(i)
        }
        return array
    }
    
    // Funktion zum Überprüfen und Aktualisieren des Highscores
    func checkScore() {
        highScoreManager.newScoreActivityCount(activityCount: activityCount, personName: playerName, difficulty: difficulty)
        highScoreManager.newScoreTime(time: time, personName: playerName, difficulty: difficulty)
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
    func addScaleRow(faktor: Int, row1: Int, row2: Int, divOrMulti: Model.DivOrMulti) {
        model.addScaledRow(faktor: faktor, row1: row1, row2: row2, divOrMulti: divOrMulti, positivNegativ: positivNegativ)
    }
    
    func scaleRow(faktor: Int, row: Int, divOrMulti: Model.DivOrMulti) {
        model.scaleRow(faktor: faktor, row: row, divOrMulti: divOrMulti, positivNegativ: positivNegativ)
    }
    
    // Funktion zur Überprüfung der Skalierung im Modell
    func controlScale(row: Int, faktor: Int, divOrMulti: Model.DivOrMulti) -> Bool {
        model.controlScale(row: row, faktor: faktor, divOrMulti: divOrMulti)
    }
    
    // Funktion zum Markieren von gezogenen Zeilen oder Spalten im Modell
    func drag(item: Int, bool: Bool, rowOrColumn: Model.RowOrColumn) {
        model.drag(item: item, bool: bool, rowOrColumn: rowOrColumn)
    }
    
    // Funktion zum Erstellen einer neuen Matrix mit einer bestimmten Zeilenanzahl
    func newMatrix(rowCount: Int, difficulty: Model.Difficulty) {
        model = ViewModel.createSetGame(rowCount: rowCount, difficulty: difficulty)
        model.generateMatrix()
    }
    
    // Funktion zum Zurücksetzen von Variablen der Fields im Modell
    func varReset() {
        model.varReset()
    }
    
    // Funktionen zum Zurück- und Vorgehen der Matrizen im Modell (undo und redo)
    func back() {
        model.back()
    }
    
    func forward() {
        model.forward()
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
    func updateSelection(item: Int, selection: Bool, rowOrColumn: Model.RowOrColumn) {
        model.updateSelection(item: item, selection: selection, rowOrColumn: rowOrColumn)
    }

    // Funktion zum Wechseln der Hintergrundfarbe
    func colorSwitchStatus() {
        switch gameStatus {
        case .start:
            gradientColors = [colorSwitchDifficulty(), Color.white]
        case .play:
            gradientColors = [Color.white, colorSwitchDifficulty()]
        case .winning:
            gradientColors = [Color.white, Color.yellow]
        case .highScore:
            gradientColors = [colorSwitchDifficulty(), Color.white]
        }
    }

    // Funktion zum Wechseln der Farbe je nach Schwierigkeitsgrad
    func colorSwitchDifficulty() -> Color {
        switch difficulty {
        case .easy:
            return Color.green
        case .normal:
            return Color.cyan
        case .hard:
            return Color.red
        }
    }

    // Enum für verschiedene Spielstatus
    enum GameStatus {
        case start, play, winning, highScore
    }
}
