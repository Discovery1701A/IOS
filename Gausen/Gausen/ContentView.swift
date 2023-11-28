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
            HStack {
                mischen
                neu
                splate
            }
        }
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
            modelView.columnSwitch(column1: 0, column2: 1)
        }, label: {
            Text("spalte")
        })
    }
    @ViewBuilder
    var neu: some View {
        Button(action: {
            modelView.newMatrix()
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
