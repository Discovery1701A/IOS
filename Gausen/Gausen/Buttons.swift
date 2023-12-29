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
        Button(
            action: {
            modelView.forwart()
            modelView.resetSelection()
            }, label: {
            Image(systemName:
                    "arrowshape.turn.up.forward").font(.title)
            }
        )
        .disabled(modelView.currentNode.successor == nil)
        .disabled(modelView.gameStatus != .play)
    }

    @ViewBuilder
    func undo() -> some View {
        Button(
            action: {
                modelView.back()
                modelView.resetSelection()
            },
            label: { Image(systemName: "arrowshape.turn.up.backward").font(.title)
            }
        )
        .disabled(modelView.currentNode.predecessor == nil)
        .disabled(modelView.gameStatus != .play)
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
        .disabled(modelView.gameStatus != .play)
    }

    @ViewBuilder
    func startButton() -> some View {
        Button(
            action: {
                modelView.newMatrix(rowCount: Int(modelView.rowCount))
                modelView.resetSelection()
                modelView.gameStatus = .play
            },
            label: {
                Text("Start")
            }
        )
    }

    @ViewBuilder
    func weiterButton() -> some View {
        Button(
            action: {
                modelView.checkScore()
                modelView.gameStatus = .highScore
            }, label: {
                 Text("Weiter")
            }
        )
    }
    
    @ViewBuilder
    func highScoreButton() -> some View {
        Button(
            action: {
//                modelView.checkScore()
                modelView.gameStatus = .highScore
            }, label: {
                Image(systemName:"medal").font(.title)
            }
        )
    }

    @ViewBuilder
    func backButton() -> some View {
        Button(
            action: {
                modelView.resetSelection()
                modelView.gameStatus = .start
            }, label: {
                Text("Zurück")
            }
        )
        .disabled(modelView.gameStatus != .play && modelView.gameStatus != .highScore)
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
        .disabled(modelView.gameStatus != .play)
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
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.secondary)
                        .scaledToFit()
                        
                    HStack {
                        Image(systemName:"multiply").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Image(systemName:"plus").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    }
                }
            }
        )
        .disabled(modelView.selectedRows.count != 2)
        .disabled(modelView.gameStatus != .play)
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
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.secondary)
                        .scaledToFit()
                        
                    HStack {
                        Image(systemName:"divide").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Image(systemName:"plus").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    }
                }
            }
        )
        .disabled(modelView.selectedRows.count != 2)
        .disabled(modelView.gameStatus != .play)
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
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.secondary)
                        .scaledToFit()
                        
                    HStack {
                        Image(systemName:"divide").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    }
                }
            }
        )
        .disabled(modelView.selectedRows.count != 1)
        .disabled(modelView.gameStatus != .play)
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
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.secondary)
                        .scaledToFit()
                        
                    HStack {
                        Image(systemName:"multiply").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    }
                }
            }
        )
        .disabled(modelView.selectedRows.count != 1)
        .disabled(modelView.gameStatus != .play)
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
        .disabled(modelView.gameStatus != .play)
    }
}
