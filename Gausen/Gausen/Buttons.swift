//
//  Buttons.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.12.23.
//

import SwiftUI

// Struct verschiedene Buttons beinhält, die Aktionen im Zusammenhang mit dem ModelView auslösen

struct Buttons {
    @ObservedObject var modelView: ViewModel
    // Button für das Vorgehen (Redo) im Spiel
    @ViewBuilder
    func redo() -> some View {
        Button(
            action: {
                // Wechselt zum nächsten Zustand in der Verlaufsliste
                modelView.forwart()
                // Setzt die Auswahl zurück
                modelView.resetSelection()
            },
            label: {
                Image(systemName: "arrowshape.turn.up.forward").font(.title)
            }
        )
        // Deaktiviert den Button, wenn es keinen nächsten Zustand gibt oder das Spiel nicht im Play Status ist
        .disabled(modelView.currentNode.successor == nil)
        .disabled(modelView.gameStatus != .play)
    }

    // Button für das Rückgängigmachen (Undo) des Spiels
    @ViewBuilder
    func undo() -> some View {
        Button(
            action: {
                // Wechselt zum vorherigen Zustand in der Verlaufsliste
                modelView.back()
                // Setzt die Auswahl zurück
                modelView.resetSelection()
            },
            label: {
                Image(systemName: "arrowshape.turn.up.backward").font(.title)
            }
        )
        // Deaktiviert den Button, wenn es keinen vorherigen Zustand gibt oder das Spiel nicht im Play Status ist
        .disabled(modelView.currentNode.predecessor == nil)
        .disabled(modelView.gameStatus != .play)
    }

    // Button zum Mischen der Matrix grade nicht auf der Benutzeroberfläche
    @ViewBuilder
    func mix() -> some View {
        Button(
            action: {
                // Setzt das Modell zurück und mischt die Matrix
                modelView.varReset()
                modelView.mixMatrix(howMany: modelView.matrix.count - 1, range: 10)
                // Setzt die Auswahl zurück
                modelView.resetSelection()
            },
            label: {
                Text("Mischen")
            }
        )
        // Deaktiviert den Button, wenn das Spiel beendet ist
        .disabled(modelView.gameStatus != .play)
    }

    // Button zum Starten eines neuen Spiels
    @ViewBuilder
    func startButton() -> some View {
        Button(
            action: {
                // Erstellt eine neue Matrix basierend auf der angegebenen Zeilenanzahl
                modelView.newMatrix(rowCount: Int(modelView.rowCount), difficulty: modelView.difficulty)
                // Setzt die Auswahl zurück
                modelView.resetSelection()
                modelView.fieldSize = .zero
                // Setzt den Spielstatus auf "Spielen"
                modelView.gameStatus = .play
            },
            label: {
                Text("Start")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                
            }
        )
    }

    // Button zum Fortfahren nach dem Spielende
    @ViewBuilder
    func weiterButton() -> some View {
        Button(
            action: {
                // Überprüft den Punktestand und wechselt zum Highscore-Bildschirm
                modelView.checkScore()
                modelView.gameStatus = .highScore
            },
            label: {
                Text("Weiter")
            }
        )
    }

    // Button zum Anzeigen des Highscore-Bildschirms
    @ViewBuilder
    func highScoreButton() -> some View {
        Button(
            action: {
                // Wechselt zum Highscore-Bildschirm
                modelView.gameStatus = .highScore
            },
            label: {
                Image(systemName: "medal").font(.largeTitle)
            }
        )
    }

    // Button zum Zurückkehren zum Startbildschirm
    @ViewBuilder
    func backButton() -> some View {
        Button(
            action: {
                // Setzt die Auswahl zurück und wechselt zum Startbildschirm
                modelView.resetSelection()
                modelView.gameStatus = .start
            },
            label: {
                Image(systemName: "house").font(.largeTitle)
            }
        )
        // Deaktiviert den Button, wenn das Spiel nicht im Play Status ist oder sich im Highscore-Status befindet
        .disabled(modelView.gameStatus != .play && modelView.gameStatus != .highScore)
    }

    // Button zum Vertauschen von Spalten grade nicht auf der Benutzeroberfläche
    @ViewBuilder
    func spalte() -> some View {
        Button(
            action: {
                // Setzt das Modell zurück und tauscht die ausgewählten Spalten
                modelView.varReset()
                if let firstColumn = modelView.selectedColumns.first, let secondColumn = modelView.selectedColumns.dropFirst().first {
                    modelView.columnSwitch(column1: firstColumn, column2: secondColumn)
                    modelView.resetSelection()
                }
                // Setzt die ausgewählten Zeilen und Spalten zurück
                modelView.selectedRows.removeAll()
                modelView.selectedColumns.removeAll()
            },
            label: {
                Text("Spalte")
            }
        )
        // Deaktiviert den Button, wenn das Spiel nicht im Play Status ist
        .disabled(modelView.gameStatus != .play)
    }

    // Button zum Hinzufügen von zwei ausgewählten Zeilen mit Multiplikation
    @ViewBuilder
    func addScaleRowMulti() -> some View {
        Button(
            action: {
                // Setzt das Modell zurück und überprüft, ob zwei Zeilen ausgewählt sind
                modelView.varReset()
                if let firstRow = modelView.selectedRows.first, let secondRow = modelView.selectedRows.dropFirst().first {
                    // Fügt die beiden ausgewählten Zeilen mit Multiplikation hinzu
                    modelView.addScaleRow(faktor: Int(modelView.faktor), row1: firstRow, row2: secondRow, multi: true)
                }
                // Setzt die Auswahl zurück
                modelView.resetSelection()
            }, label: {
                // Darstellung des Buttons mit dem Symbol für Multiplikation und Plus
                roundRecButtonLayout(
                    content:
                    HStack {
                        Image(systemName: "multiply").font(.title)
                        Image(systemName: modelView.positivNegativ ? "minus" : "plus").font(.largeTitle)
                    }
                   
                )
            }
        )
        // Deaktiviert den Button, wenn nicht genau zwei Zeilen ausgewählt sind oder das Spiel nicht im Play Status ist
        .disabled(modelView.selectedRows.count != 2)
        .disabled(modelView.gameStatus != .play)
    }

    // Button zum Hinzufügen von zwei ausgewählten Zeilen mit Division
    @ViewBuilder
    func addScaleRowDiv() -> some View {
        Button(
            action: {
                // Setzt das Modell zurück und überprüft, ob zwei Zeilen ausgewählt sind
                modelView.varReset()
                if let firstRow = modelView.selectedRows.first, let secondRow = modelView.selectedRows.dropFirst().first {
                    // Überprüft, ob die Division durchführbar ist, und fügt dann die beiden ausgewählten Zeilen hinzu
                    if modelView.controllScale(row: firstRow, faktor: Int(modelView.faktor), multi: false) {
                        modelView.addScaleRow(faktor: Int(modelView.faktor), row1: firstRow, row2: secondRow, multi: false)
                    }
                }
                // Setzt die Auswahl zurück
                modelView.resetSelection()
            }, label: {
                // Darstellung des Buttons mit dem Symbol für Division und Plus
                roundRecButtonLayout(
                    content:
                    HStack {
                        Image(systemName: "divide").font(.title)
                        Image(systemName: modelView.positivNegativ ? "minus" : "plus").font(.largeTitle)
                    }
                   
                )
            }
        )
        // Deaktiviert den Button, wenn nicht genau zwei Zeilen ausgewählt sind oder das Spiel nicht im Play Status ist
        .disabled(modelView.selectedRows.count != 2)
        .disabled(modelView.gameStatus != .play)
    }

    // Button zum Skalieren einer ausgewählten Zeile mit Division
    @ViewBuilder
    func scaleRowDiv() -> some View {
        Button(
            action: {
                // Setzt das Modell zurück und überprüft, ob eine Zeile ausgewählt ist
                modelView.varReset()
                if let firstRow = modelView.selectedRows.first {
                    // Überprüft, ob die Division durchführbar ist, und skaliert dann die ausgewählte Zeile
                    if modelView.controllScale(row: firstRow, faktor: Int(modelView.faktor), multi: false) {
                        modelView.scaleRow(faktor: Int(modelView.faktor), row: firstRow, multi: false)
                    }
                }
                // Setzt die Auswahl zurück
                modelView.resetSelection()
            }, label: {
                // Darstellung des Buttons mit dem Symbol für Division
                roundRecButtonLayout(content: Image(systemName: "divide").font(.title))
            }
        )
        // Deaktiviert den Button, wenn nicht genau eine Zeile ausgewählt ist oder das Spiel nicht im Play Status ist
        .disabled(modelView.selectedRows.count != 1)
        .disabled(modelView.gameStatus != .play)
    }

    // Button zum Skalieren einer ausgewählten Zeile mit Multiplikation
    @ViewBuilder
    func scaleRowMulti() -> some View {
        Button(
            action: {
                // Setzt das Modell zurück und überprüft, ob eine Zeile ausgewählt ist
                modelView.varReset()
                if let firstRow = modelView.selectedRows.first {
                    // Überprüft, ob die Multiplikation durchführbar ist, und skaliert dann die ausgewählte Zeile
                    if modelView.controllScale(row: firstRow, faktor: Int(modelView.faktor), multi: true) {
                        modelView.scaleRow(faktor: Int(modelView.faktor), row: firstRow, multi: true)
                    }
                }
                // Setzt die Auswahl zurück
                modelView.resetSelection()
            },
            label: {
                // Darstellung des Buttons mit dem Symbol für Multiplikation
                roundRecButtonLayout(content: Image(systemName: "multiply").font(.title))
            }
        )
        // Deaktiviert den Button, wenn nicht genau eine Zeile ausgewählt ist oder das Spiel nicht im Play Status ist
        .disabled(modelView.selectedRows.count != 1)
        .disabled(modelView.gameStatus != .play)
    }

    // Button zum Erstellen einer neuen Matrix grade nicht auf der Benutzeroberfläche
    @ViewBuilder
    func neu() -> some View {
        Button(
            action: {
                // Erstellt eine neue Matrix mit einer festgelegten Anzahl von Zeilen
                modelView.newMatrix(rowCount: 4, difficulty: modelView.difficulty)
                // Setzt die Auswahl zurück
                modelView.resetSelection()
            },
            label: {
                Text("Neu")
            }
        )
        // Deaktiviert den Button, wenn das Spiel beendet ist
        .disabled(modelView.gameStatus != .play)
    }

    // Diese Funktion erstellt eine Slider-Ansicht mit einem Label, einem Slider, einem Wertebereich und einem Anzeigetext.
    @ViewBuilder
    func slider(from min: Int, to max: Int, for value: Binding<Double>, name: String) -> some View {
        VStack {
            // Label für den Slider
            Text(name)

            // HStack für den Slider, die Min- und Max-Werte sowie den Anzeigetext
            HStack {
                // Anzeige des Min-Werts
                Text("\(min)")

                // Slider mit dem angegebenen Wertebereich und Schritt
                Slider(
                    value: value,
                    in: Double(min) ... Double(max),
                    step: 1.0
                )
                // Deaktiviert den Slider, wenn das Spiel nicht im Play oder Start Status ist
                .disabled(modelView.gameStatus != .play && modelView.gameStatus != .start)
                // Anzeige des Max-Werts
                Text("\(max)")
            }
            .padding(.horizontal)

            // Anzeige des aktuellen Slider-Werts
            Text("\(Int(value.wrappedValue))")
        }
    }

    // Funktion für die Erstellung einer Checkbox, die zwischen positiv (+) und negativ (-) wechselt
    func positivnegativCheckBox(isChecked: Binding<Bool>) -> some View {
        Button(
            action: {
                // Toggle-Funktion für die Umkehrung des aktuellen Zustands der Checkbox
                isChecked.wrappedValue.toggle()
            },
            label: {
                // Benutzerdefinierte Schaltfläche mit einem gerundeten Rechteck und einem Symbol (Plus oder Minus)
                roundRecButtonLayout(content: Image(systemName: isChecked.wrappedValue ? "minus" : "plus").font(.largeTitle))
                    .frame(maxWidth: 80, maxHeight: 80)
            }
        )
    }
    
    // Funktion, um einen benutzerdefinierten Picker für ints
    func intPicker(size: Binding<Int>, from value1: Int, to value2: Int, label : String) -> some View {
        VStack {
            Text(label).font(.title)
            Picker(label, selection: size) {
                // Iteriere durch die Werte von value1 bis value2
                ForEach(self.modelView.valueArray(from: value1, to: value2), id: \.self) { value in
                    // Benutzerdefinierte Textansicht für jedes Element im Picker
                    Text("\(value)")
                        .tag(value) // Setze den Tag-Wert für jedes Element
                        .foregroundColor(size.wrappedValue == value ? .blue : .primary) // Blau für ausgewähltes Element, sonst primäre Textfarbe
                        .onTapGesture {
                            size.wrappedValue = value // Aktualisiere die ausgewählte Größe bei Tap
                        }
                }
            }
            .pickerStyle(SegmentedPickerStyle()) // Verwende den Segmented Picker Style
        }
    }
    
    // Funktion, um einen benutzerdefinierten Picker für Difficulty
    func difficutltyPicker(difficulty: Binding<ViewModel.Difficulty>, array : [ViewModel.Difficulty], label : String) -> some View {
        VStack {
            Text(label).font(.title)
            Picker(label, selection: difficulty) {
                // Iteriere durch die Werte von value1 bis value2
                ForEach(array, id: \.self) { value in
                    // Benutzerdefinierte Textansicht für jedes Element im Picker
                    Text(value.stringValue())
                      
                }
            }
            .pickerStyle(SegmentedPickerStyle()) // Verwende den Segmented Picker Style
        }
    }

    // Funktion für das Layout einer runden Rechteck-Schaltfläche mit einem angegebenen Inhalt
    func roundRecButtonLayout(content: some View) -> some View {
        ZStack {
            // Gerundetes Rechteck als Hintergrund der Schaltfläche
           
                RoundedRectangle(cornerRadius: 8)
                .fill(.secondary)
                .scaledToFit()
           
            // Inhalt der Schaltfläche (z. B. ein Symbol)
            content
        }
    }
}
