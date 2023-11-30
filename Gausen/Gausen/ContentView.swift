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
    @State private var selectedRows: Set<Int> = []
    @State private var selectedColumns: Set<Int> = []

    var body: some View {
            VStack {
                HStack {
                    Spacer()
                    // Auswahlansicht für Reihen
                    SelectionView(items: Array(0..<modelView.matrix.count), selectedItems: $selectedColumns, axis: .horizontal)
                }

                ForEach(0..<modelView.matrix.count, id: \.self) { row in
                    HStack {
                        // Auswahlansicht für Spalten
                        SelectionView(items: [row], selectedItems: $selectedRows, axis: .vertical).padding()
                        
                        ForEach(0..<modelView.matrix[row].count, id: \.self) { column in
                            FieldView(field: modelView.matrix[row][column])
                                .onTapGesture {
                                    // Hier kannst du die Logik für das Tippen auf ein Feld implementieren
                                }
                                .border(selectedRows.contains(row) || selectedColumns.contains(column) ? Color.red : Color.clear, width: 2)
                        }
                    }
                }
                .padding()

                controller()
            }
        }

    @ViewBuilder
    func controller() -> some View {
        VStack {
            HStack {
                mischen
                neu
                splate
                addScaleRowMulti
            }
            .padding()

            HStack {
                slider(from: -2, to: 2, for: $faktor, name: "faktor")
            }
        }
    }

    @ViewBuilder
    func slider(from min: Int, to max: Int, for value: Binding<Double>, name: String) -> some View {
        Slider(value: value,
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
               selectedRows = []
               selectedColumns = []
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
            selectedRows = []
            selectedColumns = []
        }, label: {
            Text("Multiplizieren")
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
                   shape.strokeBorder(lineWidth: geometry.size.width / DrawingConstants.lineWidthDiv)
                   Text(String(field.content)).font(font(in: geometry.size))

               }
           }
       }

       private func font(in size: CGSize) -> Font {
           Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
       }

       enum DrawingConstants {
           static let cornerRadius: CGFloat = 20
           static let lineWidthDiv: CGFloat = 40
           static let fontScale: CGFloat = 0.7
       }
   }

   struct ContentView_Previews: PreviewProvider {
       static var previews: some View {
           let modelView = ViewModel()
           ContentView(modelView: modelView)
       }
   }

struct SelectionView: View {
    var items: [Int]
    @Binding var selectedItems: Set<Int>
    var axis: Axis

    var body: some View {
        VStack {
            if axis == .vertical {
                ForEach(items, id: \.self) { item in
                    Button(action: {
                        toggleSelection(item: item)
                    }, label: {
                        Text("\(item + 1)")
                            .padding(5)
                            .background(selectedItems.contains(item) ? Color.blue : Color.clear)
                            .cornerRadius(5)
                    })
                }
            } else {
                HStack {
                    ForEach(items, id: \.self) { item in
                        Button(action: {
                            toggleSelection(item: item)
                        }, label: {
                            Text("\(item + 1)")
                                .padding(5)
                                .background(selectedItems.contains(item) ? Color.blue : Color.clear)
                                .cornerRadius(5)
                        })
                    }
                }
            }
        }
        .padding(5)
    }

    private func toggleSelection(item: Int) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            selectedItems.insert(item)
        }
    }
}
