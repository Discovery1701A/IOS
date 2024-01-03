//
//  WinningView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 29.12.23.
//
// Die Ansicht, die angezeigt wird, wenn der Spieler das Spiel gewonnen hat.
import SwiftUI

// Die Ansicht für den Gewinnzustand des Spiels.
struct WinningView: View {
    @ObservedObject var modelView: ViewModel
    var buttons: Buttons

    // Initialisierung der Ansicht mit dem ViewModel und den Buttons.
    init(modelView: ViewModel) {
        self.modelView = modelView
        self.buttons = Buttons(modelView: modelView)
    }

    // Body der Ansicht, der die Struktur und das Layout definiert.
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: ConstantWinningView.cornerRadiusRec)
                    .fill(Color(hex: 0xfcbb51, alpha: 0.75))
                    .frame(maxHeight: ConstantWinningView.frameMaxHeight) // Dynamische Höhe
                    .padding(.horizontal, 20) // Optionale horizontale Polsterung
                Text("🎉Gewonnen🎉")
                    .font(.largeTitle)
            }
            .padding(.bottom, 20)
            Spacer()
            // Textfeld für die Eingabe des Spielernamens mit abgerundetem Rand.
            TextField("Name eingeben", text: $modelView.playerName)

                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(RoundedRectangle(cornerRadius: ConstantWinningView.cornerRadiusTextfield).stroke(Color.black, lineWidth: ConstantWinningView.lineWidthTextField)) // Rahmen mit abgerundeten Ecken
                .padding([.leading, .trailing], 20)
                .padding(.vertical, 10) // Vertikale Polsterung
            Spacer()
            Spacer()
            // Button zur HighScoreView.
            buttons.weiterButton()
                .padding()
        }
        .padding()
    }

    // Konstanten für die WinningView
    enum ConstantWinningView {
        static let cornerRadiusRec: CGFloat = 10
        static let frameMaxHeight: CGFloat = 100
        static let cornerRadiusTextfield: CGFloat = 5
        static let lineWidthTextField: CGFloat = 3
    }
}
