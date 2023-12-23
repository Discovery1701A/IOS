//
//  Buttons.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.12.23.
//

import SwiftUI

extension ContentView {
    @ViewBuilder
    func redo() -> some View {
        Button(action: {
            modelView.forwart()
            modelView.resetSelection()
        }, label: {
            Image(systemName: "arrow.uturn.forward")
        })
    }

    @ViewBuilder
    func undo() -> some View {
        Button(
            action: {
                modelView.back()
                modelView.resetSelection()
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
                modelView.mixMatrix(howMany: modelView.matrix.count - 1, range: 10)
                modelView.resetSelection()
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
                modelView.resetSelection()
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
                modelView.resetSelection()
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
                    modelView.resetSelection()
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
                modelView.resetSelection()
            }, label: {
                Text("Multiplizieren +")
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
                modelView.resetSelection()
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
                modelView.resetSelection()
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
                modelView.resetSelection()
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
                modelView.resetSelection()
            },
            label: {
                Text("neu")
            }
        )
    }
}