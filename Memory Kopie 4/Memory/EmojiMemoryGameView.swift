//
//  EmojiMemoryGameView.swift
//  Memory
//
//  Created by Anna Rieckmann on 21.09.23.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game : EmojiMemoryGame
    
    var body: some View {
        VStack{
            ScrollView{
        LazyVGrid(columns: [GridItem(.adaptive (minimum: 65))], content: {
            
            ForEach(game.cards, content:
                        {card in
                CardView(card: card).aspectRatio(2/3, contentMode: .fit)
                    .onTapGesture {
                        game.choose(card)
                    }
                    .padding(1) // abstand zwischen den Cardviews
            })
        }).foregroundColor(/*@START_MENU_TOKEN@*/.orange/*@END_MENU_TOKEN@*/)
    }

        }
        .padding(.horizontal)
            }
    
}


struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                let shape :RoundedRectangle = RoundedRectangle (cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp{
                    
                    shape.fill()
                    shape.foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Text (card.content).font(font (in: geometry.size))
                       
                }else if card.isMatched {
                    shape.opacity(0)
                }else{
                    
                    shape.fill()
                }
            }
        }
    }
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.8
    }
}































let game = EmojiMemoryGame() // muss auserhalb sein sonst gibt es einen Error (Ambiguous use of 'init(_:traits:body:)')
#Preview {
    
    EmojiMemoryGameView(game: game)
}
