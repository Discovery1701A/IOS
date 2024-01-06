//
//  HighScoreView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.12.23.
//
// Die HighscoreView zeigt zwei HighscoreListView-Elemente an: einen für die Zeit und einen für die Aktivitätszählung

import SwiftUI

struct HighscoreView: View {
    // Das ObservedObject highscoreManager wird für die Aktualisierung der Ansicht verwendet
    @ObservedObject var highscoreManager = HighscoreManager.shared
    @ObservedObject var viewModel: ViewModel
    var buttons: Buttons

    init(modelView: ViewModel) {
        self.viewModel = modelView
        self.buttons = Buttons(viewModel: modelView)
    }

    var body: some View {
        VStack {
            HStack {
                // Anzeige des HighscoreListView für die Zeit
                HighscoreListView(difficulty: viewModel.difficulty, title: "Highscore Zeit", highscores: highscoreManager.highScoreTime)
                // Anzeige des HighscoreListView für die Aktivitätszählung
                HighscoreListView(difficulty: viewModel.difficulty, title: "Highscore Aktion", highscores: highscoreManager.highScoreActivityCount)
            }
            buttons.backButton()
        }
    }
}

// Der HighscoreListView zeigt die Highscore-Einträge in einer vertikalen ScrollView an
struct HighscoreListView: View {
    // Schwierigkeitsgrad wird benötigt, damit die richtigen Listen angezeigt werden
    let difficulty: ViewModel.Difficulty
    let difficultyKey: String
    // Der Titel des Highscore-Typs (Zeit oder Aktivitätszählung)
    let title: String
    // Die Liste der Highscore-Einträge als zweidimensionales Array von Strings
    let highscores: [String: [[String]]]

    // Initialisieren
    init(difficulty: ViewModel.Difficulty, title: String, highscores: [String: [[String]]]) {
        self.difficulty = difficulty
        self.title = title
        self.highscores = highscores
        self.difficultyKey = String(difficulty.stringValue())
    }

    var body: some View {
        // Eine vertikale Anordnung von Ansichtselementen
        VStack {
            // Anzeige des Titels mit speziellen Formatierungen
            Text(title)
                .font(.title)
            Text(difficulty.stringValue())
                .padding(.bottom, 10)

            // Eine ScrollView für die Highscore-Einträge
            ScrollView {
                // Iteration über die Indizes der Highscore-Einträge
                ForEach(highscores[difficultyKey]!.indices, id: \.self) { index in
                    // Horizontale Anordnung für jeden Highscore-Eintrag
                    HStack {
                        // Anzeige der Platznummer
                        Text("\(index + 1).")
                            .font(.headline)
                            .foregroundColor(.primary)

                        // Anzeige des Benutzernamens
                        Text(highscores[difficultyKey]![index][0])
                            .font(.headline)
                            .foregroundColor(.primary)

                        Spacer()

                        // Anzeige der Zeit oder Aktivitätszählung
                        Text(highscores[difficultyKey]![index][1])
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    // Anwenden von Padding, Hintergrundfarbe und Rahmen für jeden Eintrag
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                            .stroke(Color(.systemGray2), lineWidth: 1)
                    )
                    // Eine subtile Trennlinie nach jedem Eintrag
                    Divider().padding(.horizontal, 16)
                }
            }
        }
        .padding()
    }
}
