//
//  HighScoreManager.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.12.23.
//
// Klasse zum Verwalten und Speichern von Highscores

import Foundation

class HighscoreManager: ObservableObject {
    static let shared = HighscoreManager()
    
    // Dateinamen für die gespeicherten Highscores
    private let highscoreFileNameTime = "highscore_time.plist"
    private let highscoreFileNameActivityCount = "highscore_activityCount.plist"
    // Arrays zur Speicherung der Highscores für Zeit und Aktivitätszählung
    var highScoreTime: [String: [[String]]] = [:]
    var highScoreActivityCount: [String: [[String]]] = [:]
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
//                // Dekodieren der Daten basierend auf der Highscore-Kategorie
                switch category {
                case .time:
                    highScoreTime = try PropertyListDecoder().decode([String: [[String]]].self, from: data)
                case .activityCount:
                    highScoreActivityCount = try PropertyListDecoder().decode([String: [[String]]].self, from: data)
                }
//                print(highScoreTime)
            } else {
                // Verwende Standardwerte, wenn keine gespeicherten Daten gefunden wurden
                switch category {
                case .time:
                    highScoreTime = defaultHighScoreList(highscoreCategory: .time)
                case .activityCount:
                    highScoreActivityCount = defaultHighScoreList(highscoreCategory: .activityCount)
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
              let seconds = Double(components[1]),
              minutes >= 0 && seconds >= 0 // Sicherstellen, dass Minuten und Sekunden nicht negativ sind
        else {
            return nil
        }
        
        // Berechnung der Gesamtzeit in Sekunden
        let totalTimeInSeconds = minutes * 60 + seconds
        return totalTimeInSeconds // Rückgabe der berechneten Gesamtzeit als Double-Wert
    }

    // Funktion zum Hinzufügen eines neuen Zeit-Highscores
    func newScoreTime(time: String, personName: String, difficulty: ViewModel.Difficulty) {
        let difficultyKey = String(difficulty.stringValue())
        // Standardwert für den zu speichernden Score
        var saveScoreRow = [" ", "99:99"]
        // Flag, um zu überprüfen, ob der neue Score bereits eingefügt wurde
        var isIn = false
        // Durchlaufe alle vorhandenen Highscores
        for i in 0 ..< highScoreTime.count {
            // Vergleiche den neuen Score mit dem aktuellen Highscore
            if convertTimeStringToDouble(saveScoreRow[1])! < convertTimeStringToDouble(highScoreTime[difficultyKey]![i][1])! {
                // Verschiebe den aktuellen Score, um Platz für den neuen zu machen
                let saveScoreRow2 = highScoreTime[difficultyKey]![i]
                highScoreTime[difficultyKey]![i] = saveScoreRow
                saveScoreRow = saveScoreRow2
            }
            // Füge den neuen Score an der richtigen Stelle ein
            if let convertedTime = convertTimeStringToDouble(time),
               convertedTime < convertTimeStringToDouble(highScoreTime[difficultyKey]![i][1])!,
               isIn == false {
                saveScoreRow = highScoreTime[difficultyKey]![i]
                highScoreTime[difficultyKey]![i] = [personName, time]
                isIn = true
            }
        }
        // Speichern der aktualisierten Highscores
        saveHighscore(for: .time)
    }

    // Funktion zum Hinzufügen eines neuen Aktivitätszählung-Highscores
    func newScoreActivityCount(activityCount: Int, personName: String, difficulty: ViewModel.Difficulty) {
        let difficultyKey = String(difficulty.stringValue())
        
        // Standardwert für den zu speichernden Score Laut recerce größter Int fürs iphone
        var saveScoreRow = [" ", "9223372036854775807"]
        // Flag, um zu überprüfen, ob der neue Score bereits eingefügt wurde
        var isIn = false
        // Durchlaufe alle vorhandenen Highscores
        for i in 0 ..< highScoreTime.count {
            // Vergleiche den neuen Score mit dem aktuellen Highscore
            if Int(saveScoreRow[1])! < Int(highScoreActivityCount[difficultyKey]![i][1])! {
                // Verschiebe den aktuellen Score, um Platz für den neuen zu machen
                let saveScoreRow2 = highScoreActivityCount[difficultyKey]![i]
                highScoreActivityCount[difficultyKey]![i] = saveScoreRow
                saveScoreRow = saveScoreRow2
            }
            // Füge den neuen Score an der richtigen Stelle ein
            if let convertedActivityCount = Int(highScoreActivityCount[difficultyKey]![i][1]),
               activityCount < convertedActivityCount && isIn == false {
                saveScoreRow = highScoreActivityCount[difficultyKey]![i]
                highScoreActivityCount[difficultyKey]![i] = [personName, String(activityCount)]
                isIn = true
            }
        }
        // Speichern der aktualisierten Highscores
        saveHighscore(for: .activityCount)
    }
    
    func defaultHighScoreList(highscoreCategory: HighscoreCategory) -> [String: [[String]]] {
        switch highscoreCategory {
        case .time:
            return [
                String(Model.Difficulty.easy.stringValue()):
                    [
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
                    ],
                String(Model.Difficulty.normal.stringValue()):
                    [
                        ["Spencer", "02:43"],
                        ["Tony", "03:53"],
                        ["Luna", "04:26"],
                        ["Barry", "05:25"],
                        ["Blake", "06:36"],
                        ["Derek", "10:35"],
                        ["Grace", "10:53"],
                        ["Alex", "12:34"],
                        ["Hope", "14:21"],
                        ["Happy", "20:43"]
                    ],
                String(Model.Difficulty.hard.stringValue()):
                    [
                        ["Spencer", "03:53"],
                        ["Bad Wolf", "04:12"],
                        ["Littel Wolf", "05:31"],
                        ["David", "06:53"],
                        ["Leo", "07:23"],
                        ["Enis", "14:12"],
                        ["Chris", "16:43"],
                        ["Sam", "18:23"],
                        ["Clint", "21:32"],
                        ["Klaus", "31:23"]
                    ]
            ]
            
        case .activityCount:
            return [
                String(Model.Difficulty.easy.stringValue()):
                    [
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
                    ],
                String(Model.Difficulty.normal.stringValue()):
                    [
                        ["Tony", "24"],
                        ["Spencer", "27"],
                        ["Elijah", "31"],
                        ["Bruce", "47"],
                        ["Ben", "52"],
                        ["J.J.", "59"],
                        ["Steve", "63"],
                        ["Violet", "68"],
                        ["Pepper", "74"],
                        ["Der Doktor", "98"]
                    ],
                String(Model.Difficulty.hard.stringValue()):
                    [
                        ["Tony", "32"],
                        ["Spencer", "34"],
                        ["Dean", "43"],
                        ["Peter", "52"],
                        ["Garcia", "59"],
                        ["Simon", "67"],
                        ["Emily", "71"],
                        ["Ruby", "84"],
                        ["Amy", "94"],
                        ["Luke", "100"]
                    ]
            ]
        }
    }
}

// Aufzählung für die verschiedenen Highscore-Kategorien
enum HighscoreCategory {
    case time
    case activityCount
}
