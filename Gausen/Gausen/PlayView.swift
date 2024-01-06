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
    var handleDrag: HandleDrag // Ein Objekt, das die Drag-and-Drop-Interaktionen behandelt

    // Initialisierer der PlayView, der das ViewModel, ein Buttons-Objekt und ein HandleDrag-Objekt entgegennimmt
    init(modelView: ViewModel, size: CGSize) {
        self.modelView = modelView
        self.buttons = Buttons(modelView: modelView)
        self.handleDrag = HandleDrag(modelView: modelView)
    }

    var body: some View {
        VStack {
            createActionInfoOverlay()
            GeometryReader { geometry in
                VStack {
                    if geometry.size.width < geometry.size.height {
                        // Vertikales Layout
                        VStack {
                            matrixView()
                                .frame(height: modelView.parentSize.height / 5 * 3)

                            controller(geometry: geometry.size)
                                .frame(height: modelView.parentSize.height / 5 * 2)
                        }
                    } else {
                        // Horizontales Layout
                        HStack {
                            matrixView()
                                .frame(width: modelView.parentSize.width / 2)

                            controller(geometry: geometry.size)
                                .frame(width: modelView.parentSize.width / 2)
                        }
                    }
                }

                .onAppear {
                    // Aktualisieren Sie die Größe des Elternelements beim Erscheinen der Ansicht
                    modelView.parentSize = geometry.size
                }
                .onChange(of: geometry.size) { _, newSize in
                    // Aktualisieren Sie die Größe des Elternelements bei Änderungen der Größe

                    modelView.parentSize = newSize
                }

                // FieldSize wird so besser bestimmt
                .onChange(of: UIDevice.current.orientation.isLandscape) { _, _ in
                    modelView.fieldSize = .zero
                }
            }
        }
    }

    @ViewBuilder
    func createActionInfoOverlay() -> some View {
        HStack {
            buttons.backButton()
            Spacer()
        }
        .overlay(
            VStack {
                Text("Anzahl der Aktionen: " + String(modelView.activityCount))
                    .foregroundStyle(.black)
                Text("Zeit: " + modelView.time + "min")
                    .foregroundStyle(.black)
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
        .padding()
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
        .rotationEffect(Angle.degrees(modelView.matrix[0][0].winning ? 360 : 0)) // Fügt eine Rotation für gewinnende Felder hinzu.
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
            .onChange(of: modelView.matrix[row][column].content) { _, _ in
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
                    // Bei einer Änderung im Drag-and-Drop ruft die entsprechende Funktion in HandleDrag auf.
                    if axis == .vertical {
                        handleDrag.handleDragChangedRow(value: value, row: item, size: modelView.fieldSize)
                    } else {
                        handleDrag.handleDragChangedColumn(value: value, column: item, size: modelView.fieldSize)
                    }
                },
                onDragEnded: {
                    // Bei Abschluss des Drag-and-Drop ruft die entsprechende Funktion in HandleDrag auf.
                    handleDrag.handleDragEnded()
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
    func controller(geometry : CGSize) -> some View {
     
            if geometry.width < geometry.height {
                VStack {
                    // Erzeugt eine horizontale HStack mit den Buttons für Matrixoperationen.
                    HStack {
                        buttons.addScaleRow(divOrMulty: .multiply)
                        buttons.addScaleRow(divOrMulty: .divide)
                        buttons.scaleRow(divOrMulty: .multiply)
                        buttons.scaleRow(divOrMulty: .divide)
                    }
                    .padding(.horizontal)
                    HStack {
                        // Erzeugt einen Slider für den Faktor mit dem dazugehörigen Label.
                        buttons.intPicker(size: $modelView.factor, from: 1, to: 10, label: "Faktor")
                        buttons.positivNegativButton(isChecked: $modelView.positivNegativ)
                        
                    }.padding(.horizontal)
                    // Erzeugt eine horizontale HStack mit den Buttons für Undo und Redo.
                    HStack {
                        Spacer()
                        buttons.undo()
                        Spacer()
                        buttons.redo()
                        Spacer()
                    }
                }
                
                //            .padding([.leading, .bottom, .trailing])
            } else {
                VStack {
                    HStack {
                        buttons.addScaleRow(divOrMulty: .multiply)
                        buttons.addScaleRow(divOrMulty: .divide)
                    }
                    .padding(.horizontal)
                    HStack {
                        buttons.scaleRow(divOrMulty: .multiply)
                        buttons.scaleRow(divOrMulty: .divide)
                    }
                    .padding(.horizontal)
                    HStack {
                        // Erzeugt einen Slider für den Faktor mit dem dazugehörigen Label.
                        buttons.intPicker(size: $modelView.factor, from: 1, to: 10, label: "Faktor")
                        buttons.positivNegativButton(isChecked: $modelView.positivNegativ)
                        
                    }.padding(.trailing)
                    // Erzeugt eine horizontale HStack mit den Buttons für Undo und Redo.
                    HStack {
                        Spacer()
                        buttons.undo()
                        Spacer()
                        buttons.redo()
                        Spacer()
                    }.padding(.bottom)
                }
            }

//        .padding()
    }

    // Konstanten für die PlayView
    enum ConstantPlayView {
        static let winningWaitTime: Double = 1.5
    }
}
