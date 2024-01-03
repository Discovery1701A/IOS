//
//  HighScoreView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.12.23.
//
// Die HighscoreView zeigt zwei HighscoreListView-Elemente an: einen für die Zeit und einen für die Aktivitätszählung
import SwiftUI

struct HighscoreView: View {
    // Der ObservedObject highscoreManager wird für die Aktualisierung der Ansicht verwendet
    @ObservedObject var highscoreManager = HighscoreManager.shared
    @ObservedObject var modelView: ViewModel
    var buttons: Buttons
    init(highScoreManager: HighscoreManager, modelView: ViewModel) {
        self.modelView = modelView
        self.buttons = Buttons(modelView: modelView)
    }

    var body: some View {
        VStack {
            HStack {
                // Anzeigen des HighscoreListView für die Zeit
                HighscoreListView(title: "Highscore Zeit", highscores: highscoreManager.highScoreTime)
                // Anzeigen des HighscoreListView für die Aktivitätszählung
                HighscoreListView(title: "Highscore Aktions Zähler", highscores: highscoreManager.highScoreActivityCount)
            }
            buttons.backButton()
        }
    }
}

// Die HighscoreListView zeigt die Highscore-Einträge in einer vertikalen ScrollView an
struct HighscoreListView: View {
    // Der Titel des Highscore-Typs (Zeit oder Aktivitätszählung)
    let title: String
    // Die Liste der Highscore-Einträge als zweidimensionales Array von Strings
    let highscores: [[String]]

    var body: some View {
        // Eine vertikale Anordnung von Ansichtselementen
        VStack {
            // Anzeigen des Titels mit speziellen Formatierungen
            Text(title)
                .font(.title)
//                .foregroundColor(.blue)
                .padding(.bottom, 10)

            // Eine ScrollView für die Highscore-Einträge
            ScrollView {
                // Iteration über die Indizes der Highscore-Einträge
                ForEach(highscores.indices, id: \.self) { index in
                    // Horizontale Anordnung für jeden Highscore-Eintrag
                    HStack {
                        // Anzeigen der Platznummer
                        Text("\(index + 1).")
                            .font(.headline)
                            .foregroundColor(.primary)

                        // Anzeigen des Benutzernamens
                        Text(highscores[index][0])
                            .font(.headline)
                            .foregroundColor(.primary)

                        // Ein Leerzeichen, um die Elemente zu trennen
                        Spacer()

                        // Anzeigen der Zeit oder Aktivitätszählung
                        Text(highscores[index][1])
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    // Anwenden von Padding, Hintergrundfarbe und Rahmen für jeden Eintrag
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )

                    // Eine subtile Trennlinie nach jedem Eintrag
                    Divider().padding(.horizontal, 16)
                }
            }
        }
        // Ein allgemeines Padding für die gesamte HighscoreListView
        .padding()
    }
}
