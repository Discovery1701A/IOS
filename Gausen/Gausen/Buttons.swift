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
    // Button für das Wiederholen (Redo) des Spiels
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
        // Deaktiviert den Button, wenn es keinen nächsten Zustand gibt oder das Spiel beendet ist
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
        // Deaktiviert den Button, wenn es keinen vorherigen Zustand gibt oder das Spiel beendet ist
        .disabled(modelView.currentNode.predecessor == nil)
        .disabled(modelView.gameStatus != .play)
    }

    // Button zum Mischen der Matrix
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
                modelView.newMatrix(rowCount: Int(modelView.rowCount))
                // Setzt die Auswahl zurück
                modelView.resetSelection()
                // Setzt den Spielstatus auf "Spielen"
                modelView.gameStatus = .play
            },
            label: {
                Text("Start")
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
                Image(systemName: "medal").font(.title)
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
                Text("Zurück")
            }
        )
        // Deaktiviert den Button, wenn das Spiel beendet ist oder sich im Highscore-Bildschirm befindet
        .disabled(modelView.gameStatus != .play && modelView.gameStatus != .highScore)
    }

    // Button zum Vertauschen von Spalten
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
        // Deaktiviert den Button, wenn das Spiel beendet ist
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
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.secondary)
                        .scaledToFit()

                    HStack {
                        Image(systemName: "multiply").font(.title)
                        Image(systemName: "plus").font(.title)
                    }
                }
            }
        )
        // Deaktiviert den Button, wenn nicht genau zwei Zeilen ausgewählt sind oder das Spiel beendet ist
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
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.secondary)
                        .scaledToFit()

                    HStack {
                        Image(systemName: "divide").font(.title)
                        Image(systemName: "plus").font(.title)
                    }
                }
            }
        )
        // Deaktiviert den Button, wenn nicht genau zwei Zeilen ausgewählt sind oder das Spiel beendet ist
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
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.secondary)
                        .scaledToFit()

                    HStack {
                        Image(systemName: "divide").font(.title)
                    }
                }
            }
        )
        // Deaktiviert den Button, wenn nicht genau eine Zeile ausgewählt ist oder das Spiel beendet ist
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
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.secondary)
                        .scaledToFit()

                    HStack {
                        Image(systemName: "multiply").font(.title)
                    }
                }
            }
        )
        // Deaktiviert den Button, wenn nicht genau eine Zeile ausgewählt ist oder das Spiel beendet ist
        .disabled(modelView.selectedRows.count != 1)
        .disabled(modelView.gameStatus != .play)
    }

    // Button zum Erstellen einer neuen Matrix
    @ViewBuilder
    func neu() -> some View {
        Button(
            action: {
                // Erstellt eine neue Matrix mit einer festgelegten Anzahl von Zeilen
                modelView.newMatrix(rowCount: 4)
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
                .disabled(modelView.gameStatus != .play)
                // Aktivierung der onChange-Methode, um Änderungen am Slider-Wert zu überwachen
                .onChange(of: value.wrappedValue) { _, _ in
                    // Aktualisierung des Bearbeitungsstatus im ViewModel, um anzuzeigen, dass der Wert bearbeitet wird
                    modelView.setIsEditing(true)
                }

                // Anzeige des Max-Werts
                Text("\(max)")
            }
            .padding(.horizontal)

            // Anzeige des aktuellen Slider-Werts mit entsprechender Textfarbe
            Text("\(Int(value.wrappedValue))")
                .foregroundColor(modelView.getIsEditing() ? .red : .blue)
        }
    }
}
