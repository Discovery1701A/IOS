//
//  SelectionView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 15.12.23.
//
// Struct für die vertikalen und horizontalen Buttons

import SwiftUI

struct SelectionView: View {
    var item: Int // Das Element, das in der Ansicht repräsentiert wird
    @Binding var selectedItems: [Int] // Ein Array, das die ausgewählten Elemente enthält (über Binding aktualisiert)
    var axis: Axis // Die Ausrichtung der Auswahlansicht (horizontal oder vertikal)
    var fieldSize: CGSize // Die Größe der einzelnen Felder in der Auswahlansicht
    var onDragChanged: ((DragGesture.Value) -> Void)? // Ein Closure, das aufgerufen wird, wenn sich die Geste ändert
    var onDragEnded: (() -> Void)? // Ein Closure, das aufgerufen wird, wenn die Geste beendet wird (optional, Standard-Closure vorhanden)

    var body: some View {
        Button(
            action: {
                // Wenn die Ausrichtung vertikal ist, die Auswahl umschalten
                if axis == .vertical {
                    toggleSelection(item: item)
                }
            },
            label: {
                // Ansicht für jedes Element
                if item >= 0 {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(
                                width: axis == .vertical ? fieldSize.width / 4 : fieldSize.width,
                                height: axis == .vertical ? fieldSize.height : fieldSize.height / 4
                            )
                            .opacity(0.5)
                            .foregroundColor(selectedItems.contains(item) ? Color.blue.opacity(1) : Color.blue.opacity(0.75))

                        Text("\(item + 1)")
                            .foregroundColor(selectedItems.contains(item) ? .white : .gray)
                    }
                    .gesture(
                        // Geste für Drag-and-Drop
                        DragGesture().onChanged { value in
                            onDragChanged?(value)
                        }
                        .onEnded { _ in
                            // Aufruf des onDragEnded Closure oder Standard-Closure, falls onDragEnded nil ist
                            onDragEnded?() ?? {}()
                        }
                    )
                }
            }
        )
    }

    // Funktion zum Umschalten der Auswahl für das übergebene Element
    private func toggleSelection(item: Int) {
        // Wenn bereits 2 oder mehr Elemente ausgewählt sind und das ausgewählte Element nicht das erste ist, entferne das erste Element
        if selectedItems.count >= 2 && selectedItems[0] != item {
            selectedItems.remove(at: 0)
        }

        // Wenn das ausgewählte Element bereits ausgewählt ist, entferne es; sonst füge es hinzu
        if let index = selectedItems.firstIndex(where: { $0 == item }) {
            selectedItems.remove(at: index)
        } else {
            selectedItems.append(item)
        }
    }
}
