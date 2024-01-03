//
//  ContentView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.11.23.
//
// Die Hauptansicht, die den Spielstatus verwaltet und die entsprechenden Unteansichten anzeigt.
import SwiftUI

struct ContentView: View {
    @ObservedObject var modelView: ViewModel

    // Der Body der Ansicht, die die Spiellogik steuert und die entsprechenden Unteransichten anzeigt.
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(
                        colors: modelView.gradiendColors
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                // Switch-Anweisung, um den aktuellen Spielstatus zu überprüfen und die entsprechende Ansicht anzuzeigen.
                switch modelView.gameStatus {
                case .start:
                    // StartView wird angezeigt, wenn das Spiel im Startstatus ist.
                    StartView(modelView: modelView)

                case .play:
                    // PlayView wird angezeigt, wenn das Spiel im Playstatus ist.
                    PlayView(modelView: modelView, size: geometry.size)

                case .winning:
                    // ZStack, um PlayView und WinningView zu überlagern, wenn das Spiel im Winningstatus ist.
                    ZStack {
                        PlayView(modelView: modelView, size: geometry.size)
                            .ignoresSafeArea(.keyboard)
                        WinningView(modelView: modelView)
                    }

                case .highScore:
                    // HighscoreView wird angezeigt, wenn das Spiel im Highscorestatus ist.
                    HighscoreView(highScoreManager: modelView.highScoreManager, modelView: modelView)
                }
            }
            .ignoresSafeArea(.keyboard)
        }
        .onChange(of: modelView.gameStatus) { _, _ in
            modelView.colorSwitch()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let modelView = ViewModel()
        ContentView(modelView: modelView)
    }
}
