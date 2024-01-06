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
        GeometryReader { geometry in
            VStack {
                // Titel der Startansicht
                Text("Start")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                Spacer()
                
                // Picker für Schwierigkeitsgrad und Größe der Matrix
                buttons.difficutltyPicker(difficulty: $modelView.difficulty, array: modelView.difficultyArray, label: "Schwierigkeitsgrad")
                    .padding([.leading, .trailing, .bottom])
                
                Spacer()
                
                buttons.intPicker(size: $modelView.rowCount, from: 2, to: 6, label: "Wie viele Reihen")
                    .padding([.leading, .trailing, .bottom])
                
                Spacer()
                if geometry.size.width < geometry.size.height {
                    // Vertikales Layout
                    VStack {
                        // Start-Button für den Spielbeginn
                        buttons.startButton()
                        
                        Spacer()
                        
                        // Button für den Zugriff auf die Highscore-Ansicht
                        buttons.highScoreButton()
                    }
                } else {
                    // Horizontales Layout
                    HStack {
                        // Start-Button für den Spielbeginn
                        Spacer()
                        
                        buttons.startButton()
                        
                        Spacer()
                        
                        // Button für den Zugriff auf die Highscore-Ansicht
                        buttons.highScoreButton()
                        Spacer()
                    }
                    Spacer()
                }
            }
            .padding() // Einfügeabstand für den gesamten Inhalt der Ansicht
        }
    }
}
