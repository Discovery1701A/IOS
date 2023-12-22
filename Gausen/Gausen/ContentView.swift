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
                if geometry.size.width < geometry.size.height {
                    VStack {
                        matrixView()
                            .fieldSize($modelView.fieldSize) // Hier wird die Größe übergeben
                            
                        Spacer()
                        controller()
                    }
                } else {
                    HStack {
                        matrixView()
                            .fieldSize($modelView.fieldSize) // Hier wird die Größe übergeben
                        Spacer()
                        controller()
                    }
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
    func matrixView() -> some View {
        VStack {
            ForEach(-1 ..< modelView.matrix.count, id: \.self) { row in
                HStack {
                    SelectionView(
                        item: row,
                        selectedItems: $modelView.selectedRows,
                        axis: .vertical,
                        fieldSize: modelView.fieldSize,
                        onDragChanged: { value in
                            handleDragChangedRow(
                                value: value,
                                row: row,
                                size: modelView.fieldSize
                            )
                        }, onDragEnded: {
                            handleDragEnded()
                        }
                    )
                    ForEach(0 ..< modelView.matrix[0].count, id: \.self) { column in
                        VStack {
                            if row >= 0 {
                                FieldView(field: modelView.matrix[row][column])
                                    .fieldSize($modelView.fieldSize)
                                    .onChange(of: modelView.selectedRows.contains(row)) { _, newValue in
                                            modelView.updateSelection(item: row, selection: newValue, axe: "row")
                                    }
//                                    .onChange(of: modelView.selectedColumns.contains(column)) { _, newValue in
//                                            modelView.updateSelection(item: column, selection: newValue, axe: "column")
//                                    }

                            } else {
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
                            }
                        }
                    }
                    SelectionView(
                        item: row,
                        selectedItems: $modelView.selectedRows,
                        axis: .vertical,
                        fieldSize: modelView.fieldSize,
                        onDragChanged: { value in
                            handleDragChangedRow(
                                value: value,
                                row: row,
                                size: modelView.fieldSize
                            )
                        }, onDragEnded: {
                            handleDragEnded()
                        }
                    )
                }
            }
        }
        .padding(1)
    }
    
    func handleDragChangedColumn(value: DragGesture.Value, column: Int, size: CGSize) {
        modelView.varReset()
        modelView.drag(column: column, bool: true)
        let translation = value.translation.width
        let columnWidth = size.width // CGFloat(modelView.matrix.first?.count ?? 1)
        var draggedColumnIndex = column + Int((value.startLocation.x + translation) / columnWidth)
        
        if Int(value.startLocation.x + translation) < 0 {
            if translation < 0 {
                draggedColumnIndex -= 1
            }
            if translation > 0 {
                draggedColumnIndex += 1
            }
        }
        modelView.drag(column: draggedColumnIndex, bool: true) // Begrenze die Position des gezogenen Rechtecks auf den erlaubten Bereich
        draggedColumnIndex = max(0, min(draggedColumnIndex, modelView.matrix.first?.count ?? 0))
        //        print(column, draggedColumnIndex, Int(value.startLocation.x + translation), value.startLocation.x, modelView.draggedColumn, Int(columnWidth), translation)
        if draggedColumnIndex != modelView.draggedColumn {
            modelView.columnSwitch(column1: modelView.draggedColumn ?? column, column2: draggedColumnIndex)
            modelView.draggedColumn = draggedColumnIndex
            //            modelView.drag( column: column, bool: false)
            //            modelView.varReset()
        }
        for i in 0 ..< modelView.matrix.count where i != draggedColumnIndex {
            modelView.drag(column: i, bool: false)
        }
    }
    
//    func handleScaleGesture(_ scale: CGFloat, row: Int) {
//        // Hier kannst du die Skalierungsfaktor-Logik implementieren
//        let scaleFactor = Double(scale) // Passe dies nach Bedarf an
//        print(scaleFactor)
//        modelView.scaleRow(faktor: Int(scaleFactor), row: row, multi: true)
//    }
    
    func handleDragChangedRow(value: DragGesture.Value, row: Int, size: CGSize) {
        modelView.varReset()
        let translation = value.translation.height
        let rowHeight = size.height // CGFloat(modelView.matrix.first?.count ?? 1)
        var draggedRowIndex = row + Int((value.startLocation.y + translation + CGFloat(row)) / rowHeight)
        
        if Int(value.startLocation.y + translation) < 0 {
            if translation < 0 {
                draggedRowIndex -= 1
//                print(draggedRowIndex, rowHeight, Int(value.startLocation.y + translation))
            }
            if translation > 0 {
                draggedRowIndex += 1
//                print(draggedRowIndex, rowHeight, Int(value.startLocation.y + translation))
            }
        }
        modelView.drag(row: draggedRowIndex, bool: true)
        // Begrenze die Position des gezogenen Rechtecks auf den erlaubten Bereich
        draggedRowIndex = max(0, min(draggedRowIndex, modelView.matrix.first?.count ?? 0))
        
        if draggedRowIndex != modelView.draggedRow {
            modelView.rowSwitch(row1: modelView.draggedRow ?? row, row2: draggedRowIndex)
            modelView.draggedRow = draggedRowIndex
        }
        for i in 0 ..< modelView.matrix.count where i != draggedRowIndex {
            modelView.drag(row: i, bool: false)
        }
    }
    
    func handleDragEnded() {
        modelView.varReset()
        modelView.draggedColumn = nil
        modelView.draggedRow = nil
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
            Text(name)
            Slider(
                value: value,
                in: Double(min) ... Double(max),
                step: 1.0
            ) {} minimumValueLabel: {
                Text(String(min))
            } maximumValueLabel: {
                Text(String(max))
            } onEditingChanged: { editing in
                modelView.setIsEditing(editing)
            }
            Text("\(Int(value.wrappedValue))")
                .foregroundColor(modelView.getIsEditing() ? .red : .blue)
        }
    
    @ViewBuilder
    func redo() -> some View {
        Button(action: {
            modelView.forwart()
        }, label: {
            Image(systemName: "arrow.uturn.forward")
        })
    }

    @ViewBuilder
    func undo() -> some View {
        Button(
            action: {
                modelView.back()
            },
            label: { Image(systemName: "arrow.uturn.backward")
            }
        )
    }
    
    @ViewBuilder
    func mix() -> some View {
        Button(
            action: {
                modelView.varReset()
                modelView.mixMatrix(howMany: modelView.matrix.count * 10, range: 10)
            }, label: {
                Text("mischen")
            }
        )
    }

    @ViewBuilder
    func startButton() -> some View {
        Button(
            action: {
                modelView.newMatrix(rowCount: Int(modelView.rowCount))
                modelView.selectedRows = []
                modelView.selectedColumns = []
                modelView.status = "play"
            }, label: {
                Text("Start")
            }
        )
    }

    @ViewBuilder
    func backButton() -> some View {
        Button(
            action: {
                modelView.selectedRows = []
                modelView.selectedColumns = []
                modelView.status = "start"
            }, label: {
                Text("Zurück")
            }
        )
    }
    
    @ViewBuilder
    func spalte() -> some View {
        Button(
            action: {
                modelView.varReset()
                if let firstColumn = modelView.selectedColumns.first, let secondColumn = modelView.selectedColumns.dropFirst().first {
                    modelView.columnSwitch(column1: firstColumn, column2: secondColumn)
                }
                modelView.selectedRows.removeAll()
                modelView.selectedColumns.removeAll()
            }, label: {
                Text("spalte")
            }
        )
    }
    
    @ViewBuilder
    func addScaleRowMulti() -> some View {
        Button(
            action: {
                modelView.varReset()
                if let firstRow = modelView.selectedRows.first, let secondRow = modelView.selectedRows.dropFirst().first {
                    modelView.addScaleRow(faktor: Int(modelView.faktor), row1: firstRow, row2: secondRow, multi: true)
                }
                modelView.selectedRows.removeAll()
                modelView.selectedColumns.removeAll()
            }, label: {
                Text("Multiplizieren")
            }
        )
    }

    @ViewBuilder
    func addScaleRowDiv() -> some View {
        Button(
            action: {
                modelView.varReset()
                if let firstRow = modelView.selectedRows.first, let secondRow = modelView.selectedRows.dropFirst().first {
                    if modelView.controllScale(row: firstRow, faktor: Int(modelView.faktor), multi: false) {
                        modelView.addScaleRow(faktor: Int(modelView.faktor), row1: firstRow, row2: secondRow, multi: false)
                    }
                }
                modelView.selectedRows.removeAll()
                modelView.selectedColumns.removeAll()
            }, label: {
                Text("Dividieren +")
            }
        )
    }

    @ViewBuilder
    func scaleRowDiv() -> some View {
        Button(
            action: {
                modelView.varReset()
                if let firstRow = modelView.selectedRows.first {
                    if modelView.controllScale(row: firstRow, faktor: Int(modelView.faktor), multi: false) {
                        modelView.scaleRow(faktor: Int(modelView.faktor), row: firstRow, multi: false)
                    }
                }
                modelView.selectedRows.removeAll()
                modelView.selectedColumns.removeAll()
            }, label: {
                Text("Dividieren")
            }
        )
    }
    
    @ViewBuilder
    func scaleRowMulti() -> some View {
        Button(
            action: {
                modelView.varReset()
                if let firstRow = modelView.selectedRows.first {
                    if modelView.controllScale(row: firstRow, faktor: Int(modelView.faktor), multi: true) {
                        modelView.scaleRow(faktor: Int(modelView.faktor), row: firstRow, multi: true)
                    }
                }
                modelView.selectedRows.removeAll()
                modelView.selectedColumns.removeAll()
            },
            label: {
                Text("Multiplizieren")
            }
        )
    }
    
    @ViewBuilder
    func neu() -> some View {
        Button(
            action: {
                modelView.newMatrix(rowCount: 4)
                modelView.selectedRows = []
                modelView.selectedColumns = []
            },
            label: {
                Text("neu")
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let modelView = ViewModel()
        ContentView(modelView: modelView)
    }
}
