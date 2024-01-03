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
                .font(.title)
                .padding(.bottom, 20)
            
            Spacer() // Platzhalter für flexiblen Raum, um die Elemente zu zentrieren
            
            // Slider für die Auswahl der Anzahl der Reihen mit entsprechendem Label und Anzeigetext
            buttons.slider(from: 2, to: 6, for: $modelView.rowCount, name: "Wie Viele Reihen")
                .padding([.leading, .trailing, .bottom])
            
            Spacer() // Platzhalter für flexiblen Raum
            
            // Start-Button für den Spielbeginn
            buttons.startButton()
                .padding()
            
            Spacer() // Platzhalter für flexiblen Raum
            Spacer() // Platzhalter für flexiblen Raum
            
            // Button für den Zugriff auf die Highscore-Ansicht
            buttons.highScoreButton()
        }
        .padding() // Einfügeabstand für den gesamten Inhalt der Ansicht
    }
}
