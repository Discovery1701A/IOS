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
        .padding()
    }
}

struct HighscoreListView: View {
    let title: String
    let highscores: [[String]]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .padding(.bottom, 10)

            ForEach(highscores, id: \.self) { entry in
                HStack {
                    Text(entry[0])
                        .font(.headline)
                    Spacer()
                    Text(entry[1])
                        .font(.subheadline)
                }
            }
        }
    }
}
