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
    @State private var isEditing = false
    @State private var selectedRows: [Int] = []
    @State private var selectedColumns: [Int] = []
    @State private var fieldSize: CGSize = .zero

    var body: some View {
        VStack {
            matrixView()
                .fieldSize($fieldSize) // Hier wird die Größe übergeben
            Spacer()
            controller()
        }
    }

    @ViewBuilder
    func matrixView() -> some View {
        VStack {
            ForEach(-1..<modelView.matrix.count, id: \.self) { row in
                HStack {
                    SelectionView(item: row, selectedItems: $selectedRows, axis: .vertical, fieldSize: fieldSize) { value in
                        handleDragChangedRow(value: value, row: row, size: fieldSize)
                    }
                    ForEach(0..<modelView.matrix[0].count, id: \.self) { column in
                        VStack {
                            if row >= 0 {
                                FieldView(field: modelView.matrix[row][column])
                                    .fieldSize($fieldSize)
                                    .border(selectedRows.contains(row) || selectedColumns.contains(column) ? Color.red : Color.clear, width: 2)
                            } else {
                                SelectionView(item: column, selectedItems: $selectedColumns, axis: .horizontal, fieldSize: fieldSize) { value in
                                    handleDragChangedColumn(value: value, column: column, size: fieldSize)
                                }
                            }
                        }
                    }
                    SelectionView(item: row, selectedItems: $selectedRows, axis: .vertical, fieldSize: fieldSize) { value in
                        handleDragChangedRow(value: value, row: row, size: fieldSize)
                    }
                }
            }
        }
    }
    
    func handleDragChangedColumn(value: DragGesture.Value, column: Int, size: CGSize) {
        let translation = value.translation.width
        let columnWidth = size.width // CGFloat(modelView.matrix.first?.count ?? 1)
        var draggedColumnIndex = column + Int((value.startLocation.x + translation) / columnWidth)
        
        // schieben ins negative
        if translation < 0 {
            draggedColumnIndex = column - Int((value.startLocation.x - translation) / columnWidth )
        }
        // Begrenze die Position des gezogenen Rechtecks auf den erlaubten Bereich
        draggedColumnIndex = max(0, min(draggedColumnIndex, modelView.matrix.first?.count ?? 0))
        //        print(column, draggedColumnIndex, Int(value.startLocation.x + translation), value.startLocation.x, modelView.draggedColumn, Int(columnWidth), translation)
        if draggedColumnIndex != modelView.draggedColumn {
            modelView.columnSwitch(column1: modelView.draggedColumn ?? column, column2: draggedColumnIndex)
            modelView.draggedColumn = draggedColumnIndex
        }
        
    }
    
    func handleDragChangedRow(value: DragGesture.Value, row: Int, size: CGSize) {
        let translation = value.translation.height
        let rowHeight = size.height / CGFloat(modelView.matrix.count) // CGFloat(modelView.matrix.first?.count ?? 1)
        var draggedRowIndex = row + Int((value.startLocation.y + translation) / rowHeight)
        
        // schieben ins negative
        if translation < 0 {
            draggedRowIndex = row - Int((value.startLocation.y - translation) / rowHeight )
        }
        // Begrenze die Position des gezogenen Rechtecks auf den erlaubten Bereich
        draggedRowIndex = max(0, min(draggedRowIndex, modelView.matrix.first?.count ?? 0))
        //        print(column, draggedColumnIndex, Int(value.startLocation.x + translation), value.startLocation.x, modelView.draggedColumn, Int(columnWidth), translation)
        if draggedRowIndex != modelView.draggedRow {
            modelView.rowSwitch(row1: modelView.draggedRow ?? row, row2: draggedRowIndex)
            modelView.draggedRow = draggedRowIndex
        }
    }
    
    func handleDragEnded() {
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
            }
            .padding()
           
                slider(from: -10, to: 10, for: $faktor, name: "faktor")
            
        }
    }
    
    @ViewBuilder
    func slider(from min: Int, to max: Int, for value: Binding<Double>, name: String) -> some View {
        Slider(
            value: value,
            in: Double(min)...Double(max),
            step: 1.0
        ) {
            Text(name)
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
            modelView.mixMatrix(howMany: 20, range: 3)
        }, label: {
            Text("mischen")
        })
    }
    
    @ViewBuilder
    var splate: some View {
        Button(action: {
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
            if let firstRow = selectedRows.first, let secondRow = selectedRows.dropFirst().first {
                modelView.addScaleRow(faktor: Int(faktor), row1: firstRow, row2: secondRow, multi: false)
            }
            selectedRows.removeAll()
            selectedColumns.removeAll()
        }, label: {
            Text("Dividieren")
        })
    }
    
    @ViewBuilder
    var neu: some View {
        Button(action: {
            modelView.newMatrix()
            selectedRows = []
            selectedColumns = []
        }, label: {
            Text("neu")
        })
    }
}

struct FieldView: View {
    let field: ViewModel.Field
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                
                shape.fill()
                shape.foregroundColor(.orange)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                //                if field.notDiv {
                //                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                //                        .foregroundColor(.red)
                //                }
                Text(String(field.content)).font(font(in: geometry.size))

            }
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geo.size)
                }
            )
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    enum DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 2
        static let fontScale: CGFloat = 0.7
    }
}

struct FieldSizeModifier: ViewModifier {
    @Binding var fieldSize: CGSize
    @State private var previousSize: CGSize = .zero
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geo.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) { size in
                // Vergleiche die vorherige Größe mit der aktuellen Größe
                if size != self.previousSize {
                    self.fieldSize = size
                    self.previousSize = size
                }
            }
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    func fieldSize(_ fieldSize: Binding<CGSize>) -> some View {
        self.modifier(FieldSizeModifier(fieldSize: fieldSize))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let modelView = ViewModel()
        ContentView(modelView: modelView)
    }
}

struct SelectionView: View {
    var item: Int
    @Binding var selectedItems: [Int]
    var axis: Axis
    var fieldSize: CGSize
    var onDragChanged: ((DragGesture.Value) -> Void)?

    var body: some View {
        Button(action: {
            toggleSelection(item: item)
        }) {
            if item >= 0 {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: axis == .vertical ? fieldSize.width / 4 : fieldSize.width,
                               height: axis == .vertical ? fieldSize.height : fieldSize.height / 4)
                        .opacity(0.5)
                        .foregroundColor(selectedItems.contains(item) ? Color.blue.opacity(1) : Color.blue.opacity(0.5))

                    Text("\(item + 1)")
                        .foregroundColor(selectedItems.contains(item) ? .white : .black)
                }
                .gesture(DragGesture().onChanged { value in
                    onDragChanged?(value)
                })
            }
        }
    }

    private func toggleSelection(item: Int) {
        if let index = selectedItems.firstIndex(where: { $0 == item }) {
            selectedItems.remove(at: index)
        } else {
            selectedItems.append(item)
        }
    }
}
