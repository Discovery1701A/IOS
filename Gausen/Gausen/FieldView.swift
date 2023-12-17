import SwiftUI

struct FieldView: View {
    let field: ViewModel.Field
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                
                shape.fill()
                shape.foregroundColor(backColor())
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                
                // Verwende eine flexible Schriftgröße basierend auf der Anzahl der Ziffern
                Text(String(field.content))
                    .font(font(in: geometry.size, content: String(field.content)))
            }
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geo.size)
                }
            )
        }
    }
    
    private func backColor() -> Color {
        if field.draged {
            return .cyan
        } else if field.notDiv {
            return Color.red
        } else if field.selection {
            return .red
        } else {
            return .orange
        }
    }
    
    private func font(in size: CGSize, content: String) -> Font {
        // Passe die Schriftgröße an, wenn die Anzahl der Ziffern größer wird
        let fontSize = min(size.width, size.height) * DrawingConstants.fontScale
        let numberOfDigits = content.count
        let adjustedFontSize = numberOfDigits > 1 ? fontSize * (1.0 / CGFloat(numberOfDigits)) : fontSize
        return Font.system(size: adjustedFontSize)
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
        modifier(FieldSizeModifier(fieldSize: fieldSize))
    }
}
