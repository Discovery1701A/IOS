//
//  ContentView.swift
//  test
//
//  Created by Anna Rieckmann on 10.12.23.
//

import SwiftUI

struct ContentView: View {
    @State private var fieldSize: CGSize = .zero
    
    var body: some View {
        VStack {
            FieldView(content: "Hello")
                .fieldSize($fieldSize) // Hier wird die Größe übergeben
            FieldView(content: "Hello")
                .fieldSize($fieldSize) // Hier wird die Größe übergeben
            FieldView(content: "Hello")
                .fieldSize($fieldSize) // Hier wird die Größe übergeben
            FieldView(content: "Hello")
                .fieldSize($fieldSize) // Hier wird die Größe übergeben
            FieldView(content: "Hello")
                .fieldSize($fieldSize) // Hier wird die Größe übergeben
            FieldView(content: "Hello")
                .fieldSize($fieldSize) // Hier wird die Größe übergeben
            FieldView(content: "Hello")
                .fieldSize($fieldSize) // Hier wird die Größe übergeben
            FieldView(content: "Hello")
                .fieldSize($fieldSize) // Hier wird die Größe übergeben
            FieldView(content: "Hello")
                .fieldSize($fieldSize) // Hier wird die Größe übergeben
            HStack{ FieldView(content: "Hello")
                    .fieldSize($fieldSize) // Hier wird die Größe übergeben
                FieldView(content: "Hello")
                    .fieldSize($fieldSize) // Hier wird die Größe übergeben
                FieldView(content: "Hello")
                    .fieldSize($fieldSize) // Hier wird die Größe übergeben
                FieldView(content: "Hello")
                    .fieldSize($fieldSize) // Hier wird die Größe übergeben
                FieldView(content: "Hello")
                    .fieldSize($fieldSize) // Hier wird die Größe übergeben
                FieldView(content: "Hello")
                    .fieldSize($fieldSize) // Hier wird die Größe übergeben
                FieldView(content: "Hello")
                    .fieldSize($fieldSize) // Hier wird die Größe übergeben
                FieldView(content: "Hello")
                    .fieldSize($fieldSize) // Hier wird die Größe übergeben
                FieldView(content: "Hello")
                    .fieldSize($fieldSize) // Hier wird die Größe übergeben
                FieldView(content: "Hello")
                    .fieldSize($fieldSize) // Hier wird die Größe übergeben
                FieldView(content: "Hello")
                    .fieldSize($fieldSize) // Hier wird die Größe übergeben
                FieldView(content: "Hello")
                    .fieldSize($fieldSize) // Hier wird die Größe übergeben
                FieldView(content: "Hello")
                    .fieldSize($fieldSize) // Hier wird die Größe übergeben
                FieldView(content: "Hello")
                    .fieldSize($fieldSize) // Hier wird die Größe übergeben
                FieldView(content: "Hello")
                    .fieldSize($fieldSize) // Hier wird die Größe übergeben
                    .overlay(
                        Text("Width: \(Int(fieldSize.width)), Height: \(Int(fieldSize.height))")
                    )
            }
        }
        .overlay(
            Text("Width: \(Int(fieldSize.width)), Height: \(Int(fieldSize.height))")
        )
        .padding()
    }
}

struct FieldView: View {
    var content : String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                
                shape.fill()
                shape.foregroundColor(.orange)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                Text(String(content)).font(font(in: geometry.size))
               
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
    
    func body(content: Content) -> some View {
        content
            .onPreferenceChange(SizePreferenceKey.self) { size in
                print(size)
                self.fieldSize = size
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
        ContentView()
    }
}

