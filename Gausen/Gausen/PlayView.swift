//
//  PlayView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 29.12.23.
//
// Die `PlayView` ist eine SwiftUI-Ansicht, die den Hauptbildschirm des Spiels repräsentiert.

import SwiftUI

struct PlayView: View {
    @ObservedObject var modelView: ViewModel // Das ViewModel-Objekt, das die Logik der Ansicht steuert
    var buttons: Buttons // Ein Objekt, das verschiedene wiederverwendbare Buttons für die Ansicht bereitstellt
    var handelDrag: HandelDrag // Ein Objekt, das die Drag-and-Drop-Interaktionen behandelt
    var size: CGSize // Die Größe der Ansicht

    // Initialisierer der PlayView, der das ViewModel, ein Buttons-Objekt und ein HandelDrag-Objekt entgegennimmt
    init(modelView: ViewModel, size: CGSize) {
        self.modelView = modelView
        self.buttons = Buttons(modelView: modelView)
        self.handelDrag = HandelDrag(modelView: modelView)
        self.size = size
    }

    var body: some View {
        
        VStack {
            HStack {
                buttons.backButton()
                Spacer()
            }
            .overlay(
                VStack {
                    Text("Anzahl der Aktionen: " + String(modelView.activityCount))
                    Text("Zeit: " + modelView.time + "min")
                        .onAppear {
                            // Aktualisieren Sie die Zeit, wenn die Ansicht erscheint
                            modelView.updateTime()
                            // Oder wenn Sie eine regelmäßige Aktualisierung wünschen, können Sie einen Timer verwenden
                            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                                modelView.updateTime()
                            }
                        }
                }
            )
            Spacer()
            if UIDevice.current.orientation.isLandscape {
                // Horizontales Layout für breitere Ansicht
                Spacer()
                HStack {
                    matrixView()
                    controller()
                }
            } else {
                // Vertikales Layout für schmalere Ansicht
                VStack {
                    matrixView()
                    controller()
                }
            }
            Spacer()
        }
//        .padding()
        
        //        FieldSize wird so besser bestimmt
                .onChange(of: UIDevice.current.orientation.isLandscape) { _, _ in
        //            print("wölfchen")
                    modelView.fieldSize = .zero
                }
    }

    // Erzeugt die Ansicht für die Spielmatrix. Verwendet eine `VStack`, um die Reihen der Matrix zu stapeln.
    @ViewBuilder
    func matrixView() -> some View {
        VStack {
            // Durchläuft die Reihen der Matrix, repräsentiert durch den Index `row`.
            ForEach(-1 ..< modelView.matrix.count, id: \.self) { row in
                // Ruft die Funktion matrixRowView auf, um die Ansicht für die aktuelle Reihe zu erstellen.
                matrixRowView(row: row)
            }
        }
        .padding()
        
    }

    // Erzeugt die Ansicht für eine Zelle in der Spielmatrix.
    func matrixCellView(row: Int, column: Int) -> some View {
        if row >= 0 {
            // Wenn es sich um eine normale Zelle handelt, ruft die Funktion createFieldView auf.
            return AnyView(createFieldView(row: row, column: column))
        } else {
            // Wenn es sich um eine Auswahlzelle handelt, ruft die Funktion createSelectionView auf.
            return AnyView(createSelectionView(item: column, axis: .horizontal))
        }
    }

    // Erzeugt die Ansicht für ein Spielfeld in der Spielmatrix.
    func createFieldView(row: Int, column: Int) -> some View {
        // Verwendet die FieldView-Ansicht und konfiguriert sie mit den Daten aus der Matrix.

        FieldView(field: modelView.matrix[row][column])

            .fieldSize($modelView.fieldSize) // Bindet die Größe des Feldes an das ViewModel.
            .ignoresSafeArea(.keyboard) // Ignoriert die sichere Bereichstastatur.
            .rotationEffect(Angle.degrees(modelView.matrix[row][column].winning ? 360 : 0)) // Fügt eine Rotation für gewinnende Felder hinzu.
            .onChange(of: modelView.selectedRows.contains(row)) { _, newValue in
                // Wenn eine Auswahl in einer Reihe geändert wird, aktualisiert das ViewModel die Auswahl und animiert die Änderung.

                withAnimation {
                    modelView.updateSelection(item: row, selection: newValue, rowOrColumn: .row)
                }
            }
            .onChange(of: modelView.matrix) { _, _ in
                // Wenn sich die Matrix ändert, überprüft das ViewModel den Spielstatus und startet bei einem Gewinn den Timer.
                withAnimation {
                    if modelView.check() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + ConstantPlayView.winningWaitTime) {
                            modelView.gameStatus = .winning
                        }
                    }
                }
            }
    }

    // Erzeugt die Ansicht für eine Auswahl in der Spielmatrix (für Drag-and-Drop).
    func createSelectionView(item: Int, axis: Axis) -> some View {
        // Verwendet die SelectionView-Ansicht für Drag-and-Drop-Interaktionen.
        withAnimation {
            SelectionView(
                item: item,
                selectedItems: axis == .vertical ? $modelView.selectedRows : $modelView.selectedColumns,
                axis: axis,
                fieldSize: modelView.fieldSize,
                onDragChanged: { value in
                    // Bei einer Änderung im Drag-and-Drop ruft die entsprechende Funktion in HandelDrag auf.
                    if axis == .vertical {
                        handelDrag.handleDragChangedRow(value: value, row: item, size: modelView.fieldSize)
                    } else {
                        handelDrag.handleDragChangedColumn(value: value, column: item, size: modelView.fieldSize)
                    }
                },
                onDragEnded: {
                    // Bei Abschluss des Drag-and-Drop ruft die entsprechende Funktion in HandelDrag auf.
                    handelDrag.handleDragEnded()
                }
            )
            // Deaktiviert die SelectionView, wenn sich das Spiel nicht im Status "play" befindet.
            .disabled(modelView.gameStatus != .play)
        }
    }

    // Erzeugt die Ansicht für eine Reihe in der Spielmatrix.
    func matrixRowView(row: Int) -> some View {
        HStack {
            // Fügt eine vertikale SelectionView am Anfang der Reihe hinzu.
            createSelectionView(item: row, axis: .vertical)

            // Durchläuft die Spalten der Matrix und erstellt die Ansicht für jede Zelle.
            ForEach(0 ..< modelView.matrix[0].count, id: \.self) { column in
                matrixCellView(row: row, column: column)
            }

            // Fügt eine weitere vertikale SelectionView am Ende der Reihe hinzu.
            createSelectionView(item: row, axis: .vertical)
        }
    }

    // Erzeugt die Ansicht für den Controller (Buttons und Slider).
    @ViewBuilder
    func controller() -> some View {
        VStack {
            // Erzeugt eine horizontale HStack mit den Buttons für Matrixoperationen.
            HStack {
                buttons.addScaleRowMulti()
                buttons.addScaleRowDiv()
                buttons.scaleRowDiv()
                buttons.scaleRowMulti()
            }
            .padding(.horizontal)
            HStack {
                // Erzeugt einen Slider für den Faktor mit dem dazugehörigen Label.
                buttons.intPicker(size: $modelView.faktor, from: 1, to: 10, label: "Faktor")
                buttons.positivnegativButton(isChecked: $modelView.positivNegativ)

            }.padding(.horizontal)
            // Erzeugt eine horizontale HStack mit den Buttons für Undo und Redo.
            HStack {
                Spacer()
                buttons.undo()
                Spacer()
                buttons.redo()
                Spacer()
            }
            .padding([.leading, .bottom, .trailing])

            // Erzeugt den "Zurück" Button am unteren Rand.
//            buttons.backButton()
        }
    }

    // Konstanten für die PlayView
    enum ConstantPlayView {
        static let winningWaitTime: Double = 1.5
    }
}
