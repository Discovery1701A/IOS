//
//  ContentView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.11.23.
//
// Die Hauptansicht, die den Spielstatus verwaltet und die entsprechenden Unteransichten anzeigt.

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel

    // Der Body der Ansicht, der die Spiellogik steuert und die entsprechenden Unteransichten anzeigt.
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: viewModel.gradientColors), // Korrektur des Schreibfehlers
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                // Switch-Anweisung, um den aktuellen Spielstatus zu überprüfen und die entsprechende Ansicht anzuzeigen.
                switch viewModel.gameStatus {
                case .start:
                    // StartView wird angezeigt, wenn das Spiel im Startstatus ist.
                    StartView(modelView: viewModel)
                        .animation(.easeInOut(duration: 1), value: UIDevice.current.orientation.isPortrait)

                case .play:
                    // PlayView wird angezeigt, wenn das Spiel im Playstatus ist.
                    PlayView(modelView: viewModel, size: geometry.size)
                        .animation(.easeInOut(duration: 1), value: viewModel.fieldSize)

                case .winning:
                    // ZStack, um PlayView und WinningView zu überlagern, wenn das Spiel im Winningstatus ist.
                    ZStack {
                        withAnimation(.easeInOut(duration: 2)) {
                            PlayView(modelView: viewModel, size: geometry.size)
                                .ignoresSafeArea(.keyboard)
                                .blur(radius: viewModel.blurRadius) // Unschärfe
                        }
                        withAnimation(.spring()) {
                            WinningView(modelView: viewModel)
                        }
                    }

                case .highScore:
                    // HighscoreView wird angezeigt, wenn das Spiel im Highscorestatus ist.
                    HighscoreView( modelView: viewModel)
                }
                
            }
            .ignoresSafeArea(.keyboard)
        }

        // Farbverlauf ändert sich bei Status- oder Schwierigkeitsänderungen
        .onChange(of: viewModel.gameStatus) { _, _ in
            withAnimation(.easeInOut(duration: 1)) {
                viewModel.colorSwitchStatus()
            }
        }
        .onChange(of: viewModel.difficulty) { _, _ in
            withAnimation(.easeInOut(duration: 1)) {
                viewModel.colorSwitchStatus()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let modelView = ViewModel()
        ContentView(viewModel: modelView)
    }
}
