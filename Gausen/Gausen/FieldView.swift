import SwiftUI

struct FieldView: View {
    let field: ViewModel.Field
//    @Binding var fieldSize: CGSize
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
//                    
//                shape
//                      .background(
//                GeometryReader { geo in
//                    Color.clear
//                        .preference(key: SizePreferenceKey.self, value: geo.size)
//                    
//                }
//            )
//            .onPreferenceChange(SizePreferenceKey.self) { size in
//                // Vergleiche die vorherige Größe mit der aktuellen Größe
//                if size != self.fieldSize {
//                    print(size)
//                    self.fieldSize = size
//                    
//                }
//            }
                
                withAnimation {
                    shape.fill().foregroundColor(backColor())
                }
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                
                // Verwende eine flexible Schriftgröße basierend auf der Anzahl der Ziffern
                withAnimation {
                    Text(String(field.content))
                        .font(font(in: geometry.size, content: String(field.content)))
                }
//                Text(String(Double(geometry.size.width)))
            }
            
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func backColor() -> Color {
        if field.winning {
            return .green
        } else if field.draged {
            return .cyan
        } else if field.notDiv {
            return Color.red
        } else if field.selection {
            return Color(hex: 0x2080A5)
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
     @State private var prepreviousSize: CGSize = .zero
    
     func body(content: Content) -> some View {
         content
             .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geo.size)
                        .onAppear {
                            
                            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                                print(self.fieldSize)
                                if self.fieldSize == .zero {
                                    self.fieldSize = geo.size
                                }
                                if geo.size == self.previousSize && geo.size != self.fieldSize {
                                 
                                        if (geo.size.width > self.fieldSize.width + 0.5)
                                            || (geo.size.width < self.fieldSize.width - 0.5) {
                                            
                                            if geo.size.height > self.fieldSize.height + 0.5
                                                || geo.size.height < self.fieldSize.height - 0.5 {
                                                if geo.size.width != 0.0 {
                                                    //                                                print("pikabu", geo.size, self.fieldSize)
                                                    self.fieldSize = self.previousSize
                                                }
                                       
                                        }
                                    }
                                }
                            }
                        }
                }
             )
             .ignoresSafeArea(.keyboard)
         
             .onPreferenceChange(SizePreferenceKey.self) { size in
                 
                 //                if size == self.previousSize && size != self.fieldSize {
                 ////                        print(content)
                 //                    self.fieldSize = size
                 //                }
                 
                 if self.fieldSize == .zero {
                     self.fieldSize = size
                 }
                 // Vergleiche die vorherige Größe mit der aktuellen Größe
                 //                if size != self.previousSize {
                 
                 //                    print(size)
//                 Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                 if  size != self.fieldSize {
                     if (size.width > self.fieldSize.width + 0.5)
                            || (size.width < self.fieldSize.width - 0.5) {
                         
                         if size.height > self.fieldSize.height + 0.5
                                || size.height < self.fieldSize.height - 0.5 {
                             self.prepreviousSize = self.previousSize
                             self.previousSize = size
//                             fieldSize = size
//                             print(self.previousSize)
                             //                print(self.prepreviousSize)
                         }
                     }
//                     }
                 }
    
                              }
//                self.prepreviousSize = self.previousSize
//                self.previousSize = size
                
//                print(self.previousSize)
//                print(size)
                
//            }
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

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex & 0xFF0000) >> 16) / 255.0,
            green: Double((hex & 0x00FF00) >> 8) / 255.0,
            blue: Double(hex & 0x0000FF) / 255.0,
            opacity: alpha
        )
    }
}
