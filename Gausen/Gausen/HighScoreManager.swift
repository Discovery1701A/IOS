//
//  HighScoreManager.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.12.23.
//

import Foundation

// Klasse zum Verwalten und Speichern von Highscores
class HighscoreManager: ObservableObject {
    static let shared = HighscoreManager()
    
    // Dateinamen für die gespeicherten Highscores
    private let highscoreFileNameTime = "highscore_time.plist"
    private let highscoreFileNameActivityCount = "highscore_activityCount.plist"
    
    // Arrays zur Speicherung der Highscores für Zeit und Aktivitätszählung
    var highScoreTime: [[String]] = []
    var highScoreActivityCount: [[String]] = []
    
    // Private Initialisierung, um sicherzustellen, dass nur eine Instanz existiert
    private init() {
        // Beim Initialisieren werden die gespeicherten Highscores geladen
        loadHighscore(for: .time)
        loadHighscore(for: .activityCount)
    }
    
    // Funktion zum Speichern von Highscores für eine bestimmte Kategorie
    func saveHighscore(for category: HighscoreCategory) {
        do {
            // Datenobjekt zum Codieren der Highscores
            let data: Data
            switch category {
            case .time:
                data = try PropertyListEncoder().encode(highScoreTime)
            case .activityCount:
                data = try PropertyListEncoder().encode(highScoreActivityCount)
            }
            
            // Dateiname entsprechend der Highscore-Kategorie
            let fileName: String
            switch category {
            case .time:
                fileName = highscoreFileNameTime
            case .activityCount:
                fileName = highscoreFileNameActivityCount
            }
            
            // Pfad zum Speichern der Daten im Dokumentenverzeichnis
            if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName) {
                // Schreibe die codierten Daten in die Datei
                try data.write(to: url)
            }
        } catch {
            // Bei einem Fehler, gib eine Fehlermeldung aus
            print("Failed to save highscore for \(category): \(error)")
        }
    }
    
    // Funktion zum Laden von Highscores für eine bestimmte Kategorie
    func loadHighscore(for category: HighscoreCategory) {
        do {
            // Dateiname entsprechend der Highscore-Kategorie
            let fileName: String
            switch category {
            case .time:
                fileName = highscoreFileNameTime
            case .activityCount:
                fileName = highscoreFileNameActivityCount
            }
            
            // Laden der Daten aus dem Dokumentenverzeichnis
            if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName),
               let data = try? Data(contentsOf: url) {
                // Dekodieren der Daten basierend auf der Highscore-Kategorie
                switch category {
                case .time:
                    highScoreTime = try PropertyListDecoder().decode([[String]].self, from: data)
                case .activityCount:
                    highScoreActivityCount = try PropertyListDecoder().decode([[String]].self, from: data)
                }
            } else {
                // Verwende Standardwerte, wenn keine gespeicherten Daten gefunden wurden
                switch category {
                case .time:
                    highScoreTime = [
                        ["Spencer", "1:10"],
                        ["Brennan", "1:34"],
                        ["Tony", "1:43"],
                        ["Julian", "2:47"],
                        ["Emma", "3:13"],
                        ["James", "5:24"],
                        ["Alex", "5:49"],
                        ["Bucky", "6:32"],
                        ["Maggi", "7:24"],
                        ["John", "9:36"]
                    ]
                case .activityCount:
                    highScoreActivityCount = [
                        ["Tony", "8"],
                        ["Spencer", "10"],
                        ["Julian", "14"],
                        ["Alex", "18"],
                        ["Jack", "25"],
                        ["Maggi", "45"],
                        ["John", "39"],
                        ["Xaden", "41"],
                        ["Emma", "42"],
                        ["James", "80"]
                    ]
                }
            }
        } catch {
            // Bei einem Fehler, gib eine Fehlermeldung aus
            print("Failed to load highscore for \(category): \(error)")
        }
    }
    
    // Funktion zum Konvertieren eines Zeit-Strings in eine Double-Zahl
    func convertTimeStringToDouble(_ timeString: String) -> Double? {
        // Zerlegen des Zeit-Strings in Minuten und Sekunden
        let components = timeString.components(separatedBy: ":")
        
        // Überprüfung, ob der String das erwartete Format (zwei Teile) hat und ob diese Teile in Double umgewandelt werden können
        guard components.count == 2,
              let minutes = Double(components[0]),
              let seconds = Double(components[1])
        else {
            return nil // Rückgabe von nil im Falle einer fehlerhaften Zeichenkette oder eines falschen Formats
        }
        
        // Berechnung der Gesamtzeit in Sekunden
        let totalTimeInSeconds = minutes * 60 + seconds
        return totalTimeInSeconds // Rückgabe der berechneten Gesamtzeit als Double-Wert
    }

    // Funktion zum Hinzufügen eines neuen Zeit-Highscores
    func newScoreTime(time: String, personName: String) {
        // Standardwert für den zu speichernden Score
        var saveScoreRow = [" ", "99:99"]
        // Flag, um zu überprüfen, ob der neue Score bereits eingefügt wurde
        var isIn = false
        // Durchlaufe alle vorhandenen Highscores
        for i in 0 ..< highScoreTime.count {
            // Vergleiche den neuen Score mit dem aktuellen Highscore
            if convertTimeStringToDouble(saveScoreRow[1])! < convertTimeStringToDouble(highScoreTime[i][1])! {
                // Verschiebe den aktuellen Score, um Platz für den neuen zu machen
                let saveScoreRow2 = highScoreTime[i]
                highScoreTime[i] = saveScoreRow
                saveScoreRow = saveScoreRow2
            }
            // Füge den neuen Score an der richtigen Stelle ein
            if convertTimeStringToDouble(time)! < convertTimeStringToDouble(highScoreTime[i][1])! && isIn == false {
                saveScoreRow = highScoreTime[i]
                highScoreTime[i] = [personName, time]
                isIn = true
            }
        }
        // Speichern der aktualisierten Highscores
        saveHighscore(for: .time)
    }

    // Funktion zum Hinzufügen eines neuen Aktivitätszählung-Highscores
    func newScoreActivityCount(activityCount: Int, personName: String) {
        // Standardwert für den zu speichernden Score Laut recerce größter Int fürs iphone
        var saveScoreRow = [" ", "9223372036854775807"]
        // Flag, um zu überprüfen, ob der neue Score bereits eingefügt wurde
        var isIn = false
        // Durchlaufe alle vorhandenen Highscores
        for i in 0 ..< highScoreTime.count {
            // Vergleiche den neuen Score mit dem aktuellen Highscore
            if Int(saveScoreRow[1])! < Int(highScoreActivityCount[i][1])! {
                // Verschiebe den aktuellen Score, um Platz für den neuen zu machen
                let saveScoreRow2 = highScoreActivityCount[i]
                highScoreActivityCount[i] = saveScoreRow
                saveScoreRow = saveScoreRow2
            }
            // Füge den neuen Score an der richtigen Stelle ein
            if activityCount < Int(highScoreActivityCount[i][1])! && isIn == false {
                saveScoreRow = highScoreActivityCount[i]
                highScoreActivityCount[i] = [personName, String(activityCount)]
                isIn = true
            }
        }
        // Speichern der aktualisierten Highscores
        saveHighscore(for: .activityCount)
    }
}

// Aufzählung für die verschiedenen Highscore-Kategorien
enum HighscoreCategory {
    case time
    case activityCount
}
