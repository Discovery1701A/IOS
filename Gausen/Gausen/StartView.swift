//
//  StartView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 29.12.23.
//
// Die StartView ist eine SwiftUI-Ansicht, die den Startbildschirm der App repräsentiert.

import SwiftUI

struct StartView: View {
    @ObservedObject var modelView: ViewModel // Das ViewModel-Objekt, das die Logik der Ansicht steuert
    var buttons: Buttons // Ein Objekt, das verschiedene wiederverwendbare Buttons für die Ansicht bereitstellt

    // Initialisierer der StartView, der das ViewModel und ein Buttons-Objekt entgegennimmt
    init(modelView: ViewModel) {
        self.modelView = modelView
        self.buttons = Buttons(modelView: modelView)
    }
    
    var body: some View {
        VStack {
            // Titel der Startansicht
            Text("Start")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            Spacer()

            // Picker für Schwierigkeitsgrad und Größe der Matrix
            buttons.difficutltyPicker(difficulty: $modelView.difficulty, array: modelView.difficultyArray, label: "Schwierigkeitsgrad")
            buttons.intPicker(size: $modelView.rowCount, from: 2, to: 6, label: "Wie viele Reihen")
                .padding([.leading, .trailing, .bottom])

            Spacer()
            
            // Start-Button für den Spielbeginn
            buttons.startButton()
                .padding()

            Spacer()
            
            // Button für den Zugriff auf die Highscore-Ansicht
            buttons.highScoreButton()
        }
        .padding() // Einfügeabstand für den gesamten Inhalt der Ansicht
    }
}
