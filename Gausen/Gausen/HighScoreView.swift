//
//  HighScoreView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.12.23.
//
import SwiftUI

struct HighscoreView: View {
    @ObservedObject var highscoreManager = HighscoreManager.shared

    var body: some View {
        HStack(spacing: 20) {
            HighscoreListView(title: "Highscore Time", highscores: highscoreManager.highScoreTime)
            HighscoreListView(title: "Highscore ActivityCount", highscores: highscoreManager.highScoreActivityCount)
        }
//        .padding()
    }
}

struct HighscoreListView: View {
    let title: String
    let highscores: [[String]]

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .foregroundColor(.blue)
                .padding(.bottom, 10)

            ForEach(highscores.indices, id: \.self) { index in
                HStack {
                    Text("\(index + 1).") // Anzeigen des Platzes
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(highscores[index][0])
                        .font(.headline)
                        .foregroundColor(.primary)

                    Spacer()

                    Text(highscores[index][1])
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )

                Divider().padding(.horizontal, 16) // Subtile Trennlinie nach jedem Eintrag
            }
        }
        .padding()
    }
}
