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
      
        AspectVGrid(items: game.cards,aspectRatio:2/3, content: {card in
            cardView(for: card)
        })
            .foregroundColor(/*@START_MENU_TOKEN@*/.orange/*@END_MENU_TOKEN@*/)
            .padding(.horizontal)
            }
    @ViewBuilder
    private func cardView(for card :EmojiMemoryGame.Card)-> some View{
        if card.isMatched && !card.isFaceUp{
            Rectangle().opacity(0)
        }else{
            CardView(card: card)
                .padding(4)
                .onTapGesture {
                    game.choose(card)
                }}
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
                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90)).padding(25).opacity(0.5)
                    Text (card.content).font(font (in: geometry.size))
                       
                
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
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.70
    }
}































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game)
    }
}
