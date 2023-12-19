import SwiftUI

struct SelectionView: View {
    var item: Int
    @Binding var selectedItems: [Int]
    var axis: Axis
    var fieldSize: CGSize
    var onDragChanged: ((DragGesture.Value) -> Void)?
    var onDragEnded: (() -> Void)?
    var handleFieldSelection : ()
    
    var body: some View {
        Button(
            action: {
                toggleSelection(item: item)
                handleFieldSelection
            },
            label: {
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
                        DragGesture().onChanged { value in
                            onDragChanged?(value)
                        }
                        .onEnded { _ in
                            onDragEnded?() ?? {}() // Default Closure, falls onDragEnded nil ist
                        }
                    )
                }
            }
        )
    }
    
    private func toggleSelection(item: Int) {
        if selectedItems.count >= 2 {
            selectedItems = []
        }
        if let index = selectedItems.firstIndex(where: { $0 == item }) {
            selectedItems.remove(at: index)
        } else {
            selectedItems.append(item)
        }
    }
}
