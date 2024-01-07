//
//  Buttons.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.12.23.
//
// Struct verschiedene Buttons beinhält, die Aktionen im Zusammenhang mit dem ModelView auslösen

import SwiftUI

struct Buttons {
    @ObservedObject var viewModel: ViewModel

    // Button für das Vorgehen (Redo) im Spiel
    @ViewBuilder
    func redo() -> some View {
        Button(
            action: {
                // Wechselt zum nächsten Zustand in der Verlaufsliste
                viewModel.forward()
                // Setzt die Auswahl zurück
                viewModel.resetSelection()
            },
            label: {
                Image(systemName: "arrowshape.turn.up.forward").font(.title)
            }
        )
        // Deaktiviert den Button, wenn es keinen nächsten Zustand gibt oder das Spiel nicht im Play Status ist
        .disabled(viewModel.currentNode.successor == nil)
        .disabled(viewModel.gameStatus != .play)
    }

    // Button für das Rückgängigmachen (Undo) des Spiels
    @ViewBuilder
    func undo() -> some View {
        Button(
            action: {
                // Wechselt zum vorherigen Zustand in der Verlaufsliste
                viewModel.back()
                // Setzt die Auswahl zurück
                viewModel.resetSelection()
            },
            label: {
                Image(systemName: "arrowshape.turn.up.backward").font(.title)
            }
        )
        // Deaktiviert den Button, wenn es keinen vorherigen Zustand gibt oder das Spiel nicht im Play Status ist
        .disabled(viewModel.currentNode.predecessor == nil)
        .disabled(viewModel.gameStatus != .play)
    }

    // Button zum Starten eines neuen Spiels
    @ViewBuilder
    func startButton() -> some View {
        Button(
            action: {
                // Erstellt eine neue Matrix basierend auf der angegebenen Zeilenanzahl
                viewModel.newMatrix(rowCount: Int(viewModel.rowCount), difficulty: viewModel.difficulty)
                // Setzt die Auswahl zurück
                viewModel.resetSelection()
                viewModel.fieldSize = .zero
                // Setzt den Spielstatus auf "Spielen"
                viewModel.gameStatus = .play
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
                viewModel.checkScore()
                viewModel.gameStatus = .highScore
            },
            label: {
                Text("Weiter")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
            }
        )
    }

    // Button zum Anzeigen des Highscore-Bildschirms
    @ViewBuilder
    func highScoreButton() -> some View {
        Button(
            action: {
                // Wechselt zum Highscore-Bildschirm
                viewModel.gameStatus = .highScore
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
                viewModel.resetSelection()
                viewModel.gameStatus = .start
            },
            label: {
                Image(systemName: "house").font(.largeTitle)
            }
        )
        // Deaktiviert den Button, wenn das Spiel nicht im Play Status ist oder sich im Highscore-Status befindet
        .disabled(viewModel.gameStatus == .winning)
    }

    // Button zum Hinzufügen von zwei ausgewählten Zeilen mit Division oder Multiplikation
    @ViewBuilder
    func addScaleRow(divOrMulty: ViewModel.DivOrMulti) -> some View {
        Button(
            action: {
                // Setzt das Modell zurück und überprüft, ob zwei Zeilen ausgewählt sind
                viewModel.varReset()
                if let firstRow = viewModel.selectedRows.first, let secondRow = viewModel.selectedRows.dropFirst().first {
                    // Überprüft, ob die Division durchführbar ist, und fügt dann die beiden ausgewählten Zeilen hinzu
                    if viewModel.controlScale(row: firstRow, faktor: viewModel.factor, divOrMulti: divOrMulty) {
                        withAnimation {
                            viewModel.addScaleRow(faktor: viewModel.factor, row1: firstRow, row2: secondRow, divOrMulti: divOrMulty)
                        }
                    }
                }
                // Setzt die Auswahl zurück
                viewModel.resetSelection()
            }, label: {
                // Darstellung des Buttons mit dem Symbol für Division oder Multiplikation und Plus oder Minus
                roundRecButtonLayout(
                    content:
                    HStack {
                        Image(systemName: divOrMulty.stringValue()).font(.title)
                        Image(systemName: viewModel.positivNegativ ? "minus" : "plus").font(.largeTitle)
                    }
                )
            }
        )
        // Deaktiviert den Button, wenn nicht genau zwei Zeilen ausgewählt sind oder das Spiel nicht im Play Status ist
        .disabled(viewModel.selectedRows.count != 2)
        .disabled(viewModel.gameStatus != .play)
    }

    // Button zum Skalieren einer ausgewählten Zeile mit Division oder Multiplikation
    @ViewBuilder
    func scaleRow(divOrMulty: ViewModel.DivOrMulti) -> some View {
        Button(
            action: {
                // Setzt das Modell zurück und überprüft, ob eine Zeile ausgewählt ist
                viewModel.varReset()
                if let firstRow = viewModel.selectedRows.first {
                    // Überprüft, ob die Division durchführbar ist, und skaliert dann die ausgewählte Zeile
                    if viewModel.controlScale(row: firstRow, faktor: viewModel.factor, divOrMulti: divOrMulty) {
                        withAnimation {
                            viewModel.scaleRow(faktor: viewModel.factor, row: firstRow, divOrMulti: divOrMulty)
                        }
                    }
                }
                // Setzt die Auswahl zurück
                viewModel.resetSelection()
            }, label: {
                // Darstellung des Buttons mit dem Symbol für Division oder Multiplikation
                roundRecButtonLayout(content: Image(systemName: divOrMulty.stringValue()).font(.title))
            }
        )
        // Deaktiviert den Button, wenn nicht genau eine Zeile ausgewählt ist oder das Spiel nicht im Play Status ist
        .disabled(viewModel.selectedRows.count != 1)
        .disabled(viewModel.gameStatus != .play)
    }

    // Funktion für die Erstellung einer Checkbox, die zwischen positiv (+) und negativ (-) wechselt
    func positivNegativButton(isChecked: Binding<Bool>) -> some View {
        Button(
            action: {
                // Toggle-Funktion für die Umkehrung des aktuellen Zustands der Checkbox
                isChecked.wrappedValue.toggle()
            },
            label: {
                // Benutzerdefinierte Schaltfläche mit einem gerundeten Rechteck und einem Symbol (Plus oder Minus)
                roundRecButtonLayout(content: Image(systemName: isChecked.wrappedValue ? "minus" : "plus").font(.largeTitle))
                    .frame(maxWidth: 80, maxHeight: 80)
//                    .foregroundStyle(.purple)
            }
        )
    }

    // Funktion, um einen benutzerdefinierten Picker für ints
    func intPicker(size: Binding<Int>, from value1: Int, to value2: Int, label: String) -> some View {
        VStack {
            Text(label).font(.title)
            Picker(label, selection: size) {
                // Iteriere durch die Werte von value1 bis value2
                ForEach(self.viewModel.valueArray(from: value1, to: value2), id: \.self) { value in
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
    func difficutltyPicker(difficulty: Binding<ViewModel.Difficulty>, array: [ViewModel.Difficulty], label: String) -> some View {
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
