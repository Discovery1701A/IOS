//
//  ContentView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.11.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var modelView : ViewModel
    var body: some View {
        VStack {
            ForEach(modelView.matrix, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.id) { column in
                        FieldView(field: column)
                    }
                }
            }
            .padding()
            
        }
    }
}

struct FieldView: View {
    
    let field: ViewModel.Field
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            
                shape.fill()
                shape.foregroundColor(.white)
                shape.strokeBorder(lineWidth: geometry.size.width / DrawingConstants.lineWidthDiv)
                Text(String(field.content)).font(font(in: geometry.size))
                
            }
        }
    }
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    // private struct DrawingConstants {
    enum DrawingConstants {
        static let symbolAspectRatio: CGFloat = 2 / 1
        static let symbolOpacity: Double = 0.7
        static let symbolCornerRadius: CGFloat = 50
        static let cornerRadius: CGFloat = 20
        static let lineWidthDiv: CGFloat = 40
        static let fontScale: CGFloat = 0.8
        static let strokeDiv: CGFloat = 35.0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let modelView = ViewModel()
        ContentView(modelView: modelView)
    }
}
