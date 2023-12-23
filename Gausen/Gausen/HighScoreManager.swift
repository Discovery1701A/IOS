//
//  HighScoreManager.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.12.23.
//
import Foundation

class HighscoreManager:  ObservableObject {
    static let shared = HighscoreManager()
    
    private let highscoreFileNameTime = "highscore_time.plist"
    private let highscoreFileNameActivityCount = "highscore_activityCount.plist"
    
    var highScoreTime: [[String]] = []
    var highScoreActivityCount: [[String]] = []
    
    private init() {
        loadHighscore(for: .time)
        loadHighscore(for: .activityCount)
    }
    
    func saveHighscore(for category: HighscoreCategory) {
        do {
            let data: Data
            switch category {
            case .time:
                data = try PropertyListEncoder().encode(highScoreTime)
            case .activityCount:
                data = try PropertyListEncoder().encode(highScoreActivityCount)
            }
            
            let fileName: String
            switch category {
            case .time:
                fileName = highscoreFileNameTime
            case .activityCount:
                fileName = highscoreFileNameActivityCount
            }
            
            if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName) {
                try data.write(to: url)
            }
        } catch {
            print("Failed to save highscore for \(category): \(error)")
        }
    }
    
    func loadHighscore(for category: HighscoreCategory) {
        do {
            let fileName: String
            switch category {
            case .time:
                fileName = highscoreFileNameTime
            case .activityCount:
                fileName = highscoreFileNameActivityCount
            }
            
            if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName),
               let data = try? Data(contentsOf: url) {
                
                switch category {
                case .time:
                    highScoreTime = try PropertyListDecoder().decode([[String]].self, from: data)
                case .activityCount:
                    highScoreActivityCount = try PropertyListDecoder().decode([[String]].self, from: data)
                }
            } else {
                // Use default values if no saved data is found
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
            print("Failed to load highscore for \(category): \(error)")
        }
    }
    
    func convertTimeStringToDouble(_ timeString: String) -> Double? {
        let components = timeString.components(separatedBy: ":")
        
        guard components.count == 2,
              let minutes = Double(components[0]),
              let seconds = Double(components[1]) else {
            return nil // Fehlerhafte Zeichenkette oder falsches Format
        }
        
        let totalTimeInSeconds = minutes * 60 + seconds
        return totalTimeInSeconds
    }
    
    func newScoreTime (time : String, personName : String) {
        print(highScoreTime)
        var saveScoreRow = [" ", "99:99"]
        var isIn = false
        for i in 0 ..< highScoreTime.count {
            if convertTimeStringToDouble(saveScoreRow[1])! < convertTimeStringToDouble(highScoreTime[i][1])! {
               var saveScoreRow2 = highScoreTime[i]
                highScoreTime[i] = saveScoreRow
                saveScoreRow = saveScoreRow2
            }
            if convertTimeStringToDouble(time)! < convertTimeStringToDouble(highScoreTime[i][1])! && isIn == false {
               saveScoreRow = highScoreTime[i]
                highScoreTime[i] = [personName, time]
                isIn = true
            }
            
        }
        saveHighscore(for: .time)
    }
    
    func newScoreActivityCount(activityCount : Int, personName : String) {
      print(highScoreActivityCount)
        var saveScoreRow = [" ", "9223372036854775807"]
        var isIn = false
        for i in 0 ..< highScoreTime.count {
            print(highScoreActivityCount[i][1])
            if Int(saveScoreRow[1])! < Int(highScoreActivityCount[i][1])! {
               var saveScoreRow2 = highScoreActivityCount[i]
                highScoreActivityCount[i] = saveScoreRow
                saveScoreRow = saveScoreRow2
            }
            if activityCount < Int(highScoreActivityCount[i][1])! && isIn == false {
               saveScoreRow = highScoreActivityCount[i]
                highScoreActivityCount[i] = [personName, String(activityCount)]
                isIn = true
            }
           
        }
        saveHighscore(for: .activityCount)
    }
    
}

enum HighscoreCategory {
    case time
    case activityCount
}
