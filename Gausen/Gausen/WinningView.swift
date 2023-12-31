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
    @ObservedObject var viewModel: ViewModel
    var buttons: Buttons

    // Initialisierung der Ansicht mit dem ViewModel und den Buttons.
    init(modelView: ViewModel) {
        self.viewModel = modelView
        self.buttons = Buttons(viewModel: modelView)
    }

    // Body der Ansicht, der die Struktur und das Layout definiert.
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: ConstantWinning.cornerRadiusRec)
                    .fill(Color(hex: 0xfcbb51, alpha: 0.75))
                    .frame(maxHeight: ConstantWinning.frameMaxHeight)
                    .blur(radius: viewModel.blurRadius) // Unschärfe
                    .padding(.horizontal, 20)
                Text("🎉Gewonnen🎉")
                    .font(.largeTitle)
            }
            .padding(.bottom, 20)
            Spacer()
            // Textfeld für die Eingabe des Spielernamens mit abgerundetem Rand.
            TextField("Name eingeben", text: $viewModel.playerName)
                .font(.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(
                    RoundedRectangle(cornerRadius: ConstantWinning.cornerRadiusText)
                        .stroke(Color.black, lineWidth: ConstantWinning.lineWidthText)
                )
                .frame(maxWidth: 400)
                .padding([.leading, .trailing], 20)
                .padding(.vertical, 10)

            Spacer()
            Spacer()
            // Button zur HighScoreView.
            buttons.weiterButton()
                .padding()
            Spacer()
        }
        .padding()
    }

    func hideKeyboard() {
        UIApplication.shared.endEditing() // Methode umbenannt, um die Aktion zu verdeutlichen
    }

    // Konstanten für die WinningView
    enum ConstantWinning {
        static let cornerRadiusRec: CGFloat = 10
        static let frameMaxHeight: CGFloat = 100
        static let cornerRadiusText: CGFloat = 5
        static let lineWidthText: CGFloat = 3
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
