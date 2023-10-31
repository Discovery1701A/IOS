//
//  EmojiMemoryGameView.swift
//  Memory
//
//  Created by Anna Rieckmann on 21.09.23.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game : EmojiMemoryGame
    
    @State private var dealt = Set<Int>()
    
    @Namespace private var dealingNamespace
    
    private func deal (_ card: EmojiMemoryGame.Card){
        dealt.insert(card.id)
    }
    
    private func isUndealt (_ card: EmojiMemoryGame.Card) -> Bool{
        return !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double (index) * (CardConstands.totalDealDuration/Double(game.cards.count))
        }
        return Animation.easeInOut (duration: CardConstands.dealDuration).delay(delay)
    }
    var body: some View {
        ZStack(alignment: .bottom) {
            
            
            VStack{
                gameBody
                
                HStack{
                    restart
                    Spacer()
                    shuffle
                }.padding(.horizontal)
            }
            deckBody
            }.padding()
        
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card: card)
                 
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                   
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                   
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(CardConstands.color)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                   .zIndex(zIndex(of: card))
            }
        }
      
        .frame(width: CardConstands.undealtWidth, height: CardConstands.undealtHeight)
        .foregroundColor(CardConstands.color)
        .onTapGesture {
          
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    
    var shuffle: some View {
        Button("Shuffle"){
            withAnimation{  // wie cool ist das dennnnnnn!!!!!!!!!!!
                game.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("Restart"){
            withAnimation{
                dealt = []
                game.restart()
            }
        }
    }
    
    private struct CardConstands {
        static let color = Color.orange
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
    
}


struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Group {
                
                 
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-91))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                      
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-91))
                 
                    }
                }
                .padding(5)
                .opacity(0.5)
            Text(card.content)
                .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
               
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .padding(5)
                .font(Font.system(size: DrawingConstants.fontSize))
            
                .scaleEffect(scale(thatFits: geometry.size))
        }
      
        .cardify(isFaceUp: card.isFaceUp)
    }
}


private func scale(thatFits size: CGSize) -> CGFloat {
    min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
}
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.70
        static let fontSize: CGFloat = 32
    }
}































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game)
    }
}
