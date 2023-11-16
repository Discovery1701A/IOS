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
                if card.isMaybeASet{
                    shape.foregroundColor(.gray)
                }
                shape.strokeBorder(lineWidth: geometry.size.width/DrawingConstants.lineWidthDiv)
                VStack {
                    ForEach(0..<card.symbol.numberOfShapes, id: \.self) { _ in
                        createSymbol(for: card, geometry: geometry)
                    }
                }.padding()
                
                if card.choosen {
                    shape.strokeBorder(lineWidth: geometry.size.width/DrawingConstants.strokeDiv)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
                
                if card.isMatched {
                    shape.strokeBorder(lineWidth:geometry.size.width/DrawingConstants.strokeDiv)
                        .foregroundColor(.green)
                        
                }
                if card.notMatched {
                    shape.strokeBorder(lineWidth:geometry.size.width/DrawingConstants.strokeDiv)
                        .foregroundColor(.red)
                }
            }
//            .cardify(isFaceUp: card.isFaceUp)
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
        static let lineWidthDiv: CGFloat = 40
        static let fontScale: CGFloat = 0.8
        static let strokeDiv: CGFloat = 35.0
    }
    
    @ViewBuilder
    func createSymbol(for card: ViewModel.Card, geometry: GeometryProxy) -> some View {
        switch card.symbol.shape {
        
        case .bean:
            createSymbolView(of: card.symbol, shape: RoundedRectangle (cornerRadius: 180),geometry:geometry)
        
        case .rect:
            createSymbolView(of: card.symbol, shape: Squiggle(),geometry:geometry)
        
        case .diamond:
            createSymbolView(of: card.symbol, shape: Diamond(),geometry:geometry)
        }
    }
    
    @ViewBuilder
    private func createSymbolView<SymbolShape>(of symbol: ViewModel.Card.CardContent, shape: SymbolShape, geometry: GeometryProxy) -> some View where SymbolShape: Shape {
        
        switch symbol.pattern {
        case .filled:
            shape.fill().foregroundColor(symbol.color.getColor()).aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit)
        
        case .transpery:
            shape.aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit).opacity(DrawingConstants.symbolOpacitytransperenty)
                .overlay(shape.stroke(lineWidth:geometry.size.width/DrawingConstants.lineWidthDiv)).foregroundColor(symbol.color.getColor())
            
        case .halftransperyt:
            shape.stroke(lineWidth: geometry.size.width/DrawingConstants.lineWidthDiv).foregroundColor(symbol.color.getColor())
                .aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit).opacity(DrawingConstants.symbolOpacity)
        }
    }
}
