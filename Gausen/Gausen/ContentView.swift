//
//  ContentView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.11.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var modelView: ViewModel
    @State private var faktor = 1.0
    @State private var rowCount = 3.0
    @State private var isEditing = false
    @State private var selectedRows: [Int] = []
    @State private var selectedColumns: [Int] = []
    @State private var fieldSize: CGSize = .zero
    
    var body: some View {
        if  modelView.status == "start"{
            start()
            
        } else if  modelView.status == "play"{
            VStack {
                
                matrixView()
                    .fieldSize($fieldSize) // Hier wird die Größe übergeben
                Spacer()
                controller()
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
            
            slider(from: 2, to: 6, for: $rowCount, name: "Wie Viele Zeilen")
                .padding([.leading, .trailing, .bottom]) // Padding auf der linken, rechten und unteren Seite
            
            Spacer()
            
            startButton
                .padding() // Standard-Padding für den Startbutton
            
            Spacer()
        }
        .padding() // Padding für den gesamten VStack
    }
    
    @ViewBuilder
    func matrixView() -> some View {
        VStack {
            ForEach(-1..<modelView.matrix.count, id: \.self) { row in
                HStack {
                    SelectionView(item: row, selectedItems: $selectedRows, axis: .vertical, fieldSize: fieldSize, onDragChanged: { value in
                        handleDragChangedRow(value: value, row: row, size: fieldSize)
                    }, onDragEnded: {
                        handleDragEnded()  // Aufruf der Funktion für DragEnded
                    })
                    ForEach(0..<modelView.matrix[0].count, id: \.self) { column in
                        VStack {
                            if row >= 0 {
                                FieldView(field: modelView.matrix[row][column])
                                    .fieldSize($fieldSize)
                                    .border(selectedRows.contains(row) || selectedColumns.contains(column) ? Color.red : Color.clear, width: 2)
                            } else {
                                SelectionView(item: column, selectedItems: $selectedColumns, axis: .horizontal, fieldSize: fieldSize, onDragChanged: { value in
                                    handleDragChangedColumn(value: value, column: column, size: fieldSize)
                                }, onDragEnded: {
                                    handleDragEnded()  // Aufruf der Funktion für DragEnded
                                })
                            }
                        }
                    }
                    SelectionView(item: row, selectedItems: $selectedRows, axis: .vertical, fieldSize: fieldSize, onDragChanged: { value in
                        handleDragChangedRow(value: value, row: row, size: fieldSize)
                    }, onDragEnded: {
                        handleDragEnded()  // Aufruf der Funktion für DragEnded
                    })
                }
            }
        }.padding(1)
    }
    
    func handleDragChangedColumn(value: DragGesture.Value, column: Int, size: CGSize) {
        modelView.varReset()
        modelView.drag( column: column, bool: true)
        let translation = value.translation.width
        let columnWidth = size.width  // CGFloat(modelView.matrix.first?.count ?? 1)
        var draggedColumnIndex = column + Int((value.startLocation.x + translation) / columnWidth)
        
        if Int((value.startLocation.x + translation)) < 0 {
            if translation < 0 {
                draggedColumnIndex -= 1
                
            }
            if  translation > 0 {
                draggedColumnIndex += 1
                
            }
            
        }
        modelView.drag(column: draggedColumnIndex, bool: true)        // Begrenze die Position des gezogenen Rechtecks auf den erlaubten Bereich
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
    
    func handleDragChangedRow(value: DragGesture.Value, row: Int, size: CGSize) {
        modelView.varReset()
        let translation = value.translation.height
        let rowHeight = size.height  // CGFloat(modelView.matrix.first?.count ?? 1)
        var draggedRowIndex = row + Int((value.startLocation.y + translation + CGFloat(row)) / rowHeight)
        
        if Int((value.startLocation.y + translation)) < 0 {
            if translation < 0 {
                draggedRowIndex -= 1
                
                print(draggedRowIndex, rowHeight, Int((value.startLocation.y + translation)))
            }
            if  translation > 0 {
                draggedRowIndex += 1
                
                print(draggedRowIndex, rowHeight, Int((value.startLocation.y + translation)))
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
                mischen
                neu
                splate
                addScaleRowMulti
                addScaleRowDiv
                scaleRowDiv
                scaleRowMulti
            }
            .padding()
            
            slider(from: -10, to: 10, for: $faktor, name: "faktor")
            backButton
        }
    }
    
    @ViewBuilder
    func slider(from min: Int, to max: Int, for value: Binding<Double>, name: String) -> some View {
        Text(name)
        Slider(
            value: value,
            in: Double(min )...Double(max),
            step: 1.0
        ) {
            
        } minimumValueLabel: {
            Text(String(min))
        } maximumValueLabel: {
            Text(String(max))
        } onEditingChanged: { editing in
            isEditing = editing
        }
        Text("\(Int(value.wrappedValue))")
            .foregroundColor(isEditing ? .red : .blue)
    }
    
    @ViewBuilder
    var mischen: some View {
        Button(action: {
            modelView.varReset()
            modelView.mixMatrix(howMany: modelView.matrix.count * 10, range: 10)
        }, label: {
            Text("mischen")
        })
    }
    @ViewBuilder
    var startButton: some View {
        Button(action: {
            modelView.newMatrix(rowCount: Int(rowCount))
            selectedRows = []
            selectedColumns = []
            modelView.status = "play"
        }, label: {
            Text("Start")
        })
    }
    @ViewBuilder
    var backButton: some View {
        Button(action: {
            selectedRows = []
            selectedColumns = []
            modelView.status = "start"
        }, label: {
            Text("Zurück")
        })
    }
    
    @ViewBuilder
    var splate: some View {
        Button(action: {
            modelView.varReset()
            if let firstColumn = selectedColumns.first, let secondColumn = selectedColumns.dropFirst().first {
                modelView.columnSwitch(column1:firstColumn, column2: secondColumn )
            }
            selectedRows.removeAll()
            selectedColumns.removeAll()
        }, label: {
            Text("spalte")
        })
    }
    
    @ViewBuilder
    var addScaleRowMulti: some View {
        Button(action: {
            modelView.varReset()
            if let firstRow = selectedRows.first, let secondRow = selectedRows.dropFirst().first {
                modelView.addScaleRow(faktor: Int(faktor), row1: firstRow, row2: secondRow, multi: true)
            }
            selectedRows.removeAll()
            selectedColumns.removeAll()
        }, label: {
            Text("Multiplizieren")
        })
    }
    @ViewBuilder
    var addScaleRowDiv: some View {
        Button(action: {
            modelView.varReset()
            if let firstRow = selectedRows.first, let secondRow = selectedRows.dropFirst().first {
                if modelView.controllScale(row: firstRow, faktor: Int(faktor), multi: false) {
                    modelView.addScaleRow(faktor: Int(faktor), row1: firstRow, row2: secondRow, multi: false)
                }
            }
            selectedRows.removeAll()
            selectedColumns.removeAll()
        }, label: {
            Text("Dividieren +")
        })
    }
    @ViewBuilder
    var scaleRowDiv: some View {
        Button(action: {
            modelView.varReset()
            if let firstRow = selectedRows.first {
                if modelView.controllScale(row: firstRow, faktor: Int(faktor), multi: false) {
                    modelView.scaleRow(faktor: Int(faktor), row: firstRow, multi: false)
                }
            }
            selectedRows.removeAll()
            selectedColumns.removeAll()
        }, label: {
            Text("Dividieren")
        })
    } 
    
    @ViewBuilder
    var scaleRowMulti: some View {
        Button(action: {
            modelView.varReset()
            if let firstRow = selectedRows.first {
                if modelView.controllScale(row: firstRow, faktor: Int(faktor), multi: true) {
                    modelView.scaleRow(faktor: Int(faktor), row: firstRow, multi: true)
                }
            }
            selectedRows.removeAll()
            selectedColumns.removeAll()
        }, label: {
            Text("Multiplizieren")
        })
    }
    
    @ViewBuilder
    var neu: some View {
        Button(action: {
            modelView.newMatrix(rowCount: 4)
            selectedRows = []
            selectedColumns = []
        }, label: {
            Text("neu")
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let modelView = ViewModel()
        ContentView(modelView: modelView)
    }
}
