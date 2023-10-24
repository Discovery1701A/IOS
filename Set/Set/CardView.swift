//
//  CardView.swift
//  Set
//
//  Created by Anna Rieckmann on 21.10.23.
//
import SwiftUI

struct CardView: View {
    let card: ViewModel.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                let shape :RoundedRectangle = RoundedRectangle (cornerRadius: DrawingConstants.cornerRadius)
               
                    
                    shape.fill()
                    shape.foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                VStack {
                    ForEach(0..<card.symbol.numberOfShapes, id: \.self) { _ in
                        createSymbol(for: card)
                    }
                }.padding()
                       
                if card.choosen {
                    shape.strokeBorder(lineWidth: 5)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
                if card.isMatched {
                    shape.strokeBorder(lineWidth: 5)
                        .foregroundColor(.green)
                }
            }
        }
    }
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    private struct DrawingConstants {
        static let symbolAspectRatio: CGFloat = 2/1
        static let symbolOpacity: Double = 0.7
        static let symbolOpacitytransperenty: Double = 0.3
        static let symbolCornerRadius: CGFloat = 50
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.8
    }
    @ViewBuilder
    func createSymbol(for card: ViewModel.Card) -> some View {
        switch card.symbol.shape {
        case .oval:
            createSymbolView(of: card.symbol, shape: Ellipse())
        case .rect:
            createSymbolView(of: card.symbol, shape: Rectangle())
        case .diamond:
            createSymbolView(of: card.symbol, shape: Diamond())
        }
    }
    @ViewBuilder
    private func createSymbolView<SymbolShape>(of symbol: ViewModel.Card.CardContent, shape: SymbolShape) -> some View where SymbolShape: Shape {
        
        switch symbol.pattern {
        case .filled:
            shape.fill().foregroundColor(symbol.color.getColor()).aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit)
        case .transpery:
            
            shape.aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit).opacity(DrawingConstants.symbolOpacitytransperenty)
                .overlay(shape.stroke(lineWidth: DrawingConstants.lineWidth)).foregroundColor(symbol.color.getColor())
            
        case .halftransperyt:
            shape.stroke(lineWidth: DrawingConstants.lineWidth).foregroundColor(symbol.color.getColor())
                .aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit).opacity(DrawingConstants.symbolOpacity)
        }
    }
}
