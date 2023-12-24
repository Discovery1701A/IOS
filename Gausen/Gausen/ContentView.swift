//
//  ContentView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.11.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var modelView: ViewModel
    
    var body: some View {
        GeometryReader { geometry in
            
            if modelView.status == "start" {
                start()
                
            } else if modelView.status == "play" {
                play(size: geometry.size)
            } else if modelView.status == "winning" {
                ZStack {
                    play(size: geometry.size)
                    VStack {
                        Text("Gewonnen").font(.largeTitle)
                        TextField("Name eingeben", text: $modelView.playerName)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        weiterButton()
                    }
                }
            } else if modelView.status == "highScore" {
                VStack {
                    HighscoreView(highscoreManager: modelView.highscoreManager)
                    backButton()
                }
            }
        }
    }
    
    @ViewBuilder
    func start() -> some View {
        VStack {
            Text("Start")
                .font(.title)
                .padding(.bottom, 20) // Abstand unterhalb des Texts
            
            Spacer()
            
            slider(from: 2, to: 6, for: $modelView.rowCount, name: "Wie Viele Zeilen")
                .padding([.leading, .trailing, .bottom])
                .padding([.leading, .trailing, .bottom]) // Padding auf der linken, rechten und unteren Seite
            
            Spacer()
            
            startButton()
                .padding() // Standard-Padding für den Startbutton
            
            Spacer()
        }
        .padding() // Padding für den gesamten VStack
    }
    
    @ViewBuilder
    func play(size: CGSize) -> some View {
        if size.width < size.height {
            VStack {
                Text(String(modelView.activityCount))
                Text(modelView.time)
                    .onAppear {
                        // Aktualisieren Sie die Zeit, wenn die Ansicht erscheint
                        modelView.updateTime()
                                
                        // Oder wenn Sie eine regelmäßige Aktualisierung wünschen, können Sie einen Timer verwenden
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                            modelView.updateTime()
                        }
                    }
                matrixView()
                    .fieldSize($modelView.fieldSize) // Hier wird die Größe übergeben
                    
                Spacer()
                controller()
            }
        } else {
            VStack {
                Text(String(modelView.activityCount))
                Text(modelView.time)
                    .onAppear {
                        // Aktualisieren Sie die Zeit, wenn die Ansicht erscheint
                        modelView.updateTime()
                                
                        // Oder wenn Sie eine regelmäßige Aktualisierung wünschen, können Sie einen Timer verwenden
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                            modelView.updateTime()
                        }
                    }
                HStack {
                    matrixView()
                        .fieldSize($modelView.fieldSize) // Hier wird die Größe übergeben
                    Spacer()
                    controller()
                }
            }
        }
    }
    
    @ViewBuilder
    func matrixView() -> some View {
        VStack {
            ForEach(-1 ..< modelView.matrix.count, id: \.self) { row in
                matrixRowView(row: row)
            }
        }
        .padding(1)
    }
    
    func matrixCellView(row: Int, column: Int) -> some View {
        if row >= 0 {
            return AnyView(createFieldView(row: row, column: column))
        } else {
            return AnyView(createSelectionView(column: column))
        }
    }

    func createFieldView(row: Int, column: Int) -> some View {
        FieldView(field: modelView.matrix[row][column])
            .fieldSize($modelView.fieldSize)
            .onChange(of: modelView.selectedRows.contains(row)) { _, newValue in
                withAnimation {
                    modelView.updateSelection(item: row, selection: newValue, axe: "row")
                }
            }
            .onChange(of: modelView.matrix) { _, _ in
                withAnimation {
                    if modelView.check() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            modelView.status = "winning"
                        }
                    }
                }
            }
    }

    func createSelectionView(column: Int) -> some View {
        SelectionView(
            item: column,
            selectedItems: $modelView.selectedColumns,
            axis: .horizontal,
            fieldSize: modelView.fieldSize,
            onDragChanged: { value in
                handleDragChangedColumn(
                    value: value,
                    column: column,
                    size: modelView.fieldSize
                )
            }, onDragEnded: {
                handleDragEnded()
            }
        )
        .disabled(modelView.status != "play")
    }

    func createSelectionView(item: Int, axis: Axis) -> some View {
        SelectionView(
            item: item,
            selectedItems: axis == .vertical ? $modelView.selectedRows : $modelView.selectedColumns,
            axis: axis,
            fieldSize: modelView.fieldSize,
            onDragChanged: { value in
                if axis == .vertical {
                    handleDragChangedRow(value: value, row: item, size: modelView.fieldSize)
                } else {
                    handleDragChangedColumn(value: value, column: item, size: modelView.fieldSize)
                }
            },
            onDragEnded: {
                handleDragEnded()
            }
        )
        .disabled(modelView.status != "play")
    }

    func matrixRowView(row: Int) -> some View {
        HStack {
            createSelectionView(item: row, axis: .vertical)

            ForEach(0 ..< modelView.matrix[0].count, id: \.self) { column in
                matrixCellView(row: row, column: column)
            }

            createSelectionView(item: row, axis: .vertical)
        }
        .disabled(modelView.status != "play")
    }
   
    @ViewBuilder
    func controller() -> some View {
        VStack {
            HStack {
                mix()
                neu()
                spalte()
                addScaleRowMulti()
                addScaleRowDiv()
                scaleRowDiv()
                scaleRowMulti()
            }
            undo()
            redo()
                .padding()
            
            slider(from: -10, to: 10, for: $modelView.faktor, name: "faktor")
            backButton()
        }
    }
    
    @ViewBuilder
    func slider(from min: Int, to max: Int, for value: Binding<Double>, name: String) -> some View {
        VStack {
            Text(name)
            
            HStack {
                Text("\(min)")
                
                Slider(
                    value: value,
                    in: Double(min) ... Double(max),
                    step: 1.0
                )
                .onChange(of: value.wrappedValue) { _, _ in
                    modelView.setIsEditing(true)
                }
                Text("\(max)")
            }
            .padding(.horizontal)
            
            Text("\(Int(value.wrappedValue))")
                .foregroundColor(modelView.getIsEditing() ? .red : .blue)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let modelView = ViewModel()
        ContentView(modelView: modelView)
    }
}
