//
//  WinningView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 29.12.23.
//
// Die Ansicht, die angezeigt wird, wenn der Spieler das Spiel gewonnen hat.
import SwiftUI

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
            // Titel "Gewonnen" mit großer Schrift.
            Text("Gewonnen").font(.largeTitle)

            // Textfeld für die Eingabe des Spielernamens mit abgerundetem Rand.
            TextField("Name eingeben", text: $modelView.playerName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Button zum Fortsetzen (Weiter).
            buttons.weiterButton()
        }
        .padding(EdgeInsets())
    }
}
