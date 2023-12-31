//
//  ContentView.swift
//  Set
//
//  Created by Anna Rieckmann on 19.10.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game : ViewModel
    
//    @State private var dealt = Set<Int>()
//    
//    @Namespace private var dealingNamespace
//    
//    private func deal (_ card: ViewModel.Card){
//        dealt.insert(card.id)
//        game.deal()
//    }
//    
//    private func isUndealt (_ card: ViewModel.Card) -> Bool{
//        return !dealt.contains(card.id)
//    }
//    
//    private func dealAnimation(for card: ViewModel.Card) -> Animation {
//        var delay = 0.0
//        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
//            delay = Double (index) * (CardConstands.totalDealDuration/Double(game.cards.count))
//        }
//        return Animation.easeInOut (duration: CardConstands.dealDuration).delay(delay)
//    }
//    
    var body: some View {
        VStack{
            cardView()
            
        }
    }
    
    @ViewBuilder
    private func cardView()-> some View{
        if  game.setAvailableInPlayedCards || game.setAvailableInAllCards{
            
            Text("Sets: " + String(game.score)).font(.largeTitle).padding()
            AspectVGrid(items: game.cards,aspectRatio:2/3, content: {card in
//                if isUndealt(card) || (card.isMatched ){
//                    Color.clear
//                } else {
//                    
                    CardView(card: card)
//                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
//                        .padding(4)
//                    
//                        .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
//                        .zIndex(zIndex(of: card))
//                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
//                        
                        .onTapGesture {
                            withAnimation(.linear(duration: 1)) {
                                game.choose(card)
                            }
                        }
//                }
            }).foregroundColor(/*@START_MENU_TOKEN@*/.orange/*@END_MENU_TOKEN@*/)
            
            HStack{
                ZStack{
//                    deckBody
                    newCards
                }
                
                Spacer()
                cheat
                Spacer()
                newGame
            }.padding(.horizontal)
            Text(String(game.allCards.count))
        } else {
            VStack{
                Spacer()
                Text("Gewonnen!!")
                
                Text("Sets: " + String(game.score))
                Spacer()
                newGame.foregroundColor(.blue)
            }
            .font(.largeTitle)
            .fontWeight(/*@START_MENU_TOKEN@*/.heavy/*@END_MENU_TOKEN@*/)
            .foregroundColor(.red)
        }
    }
    
//    private func zIndex(of card: ViewModel.Card) -> Double {
//        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
//    }
    
//    var deckBody: some View {
//        ZStack {
//            ForEach(game.cards.filter(isUndealt)) { playcard in
//                
//                    CardView(card: playcard)
//                        .matchedGeometryEffect(id: playcard.id, in: dealingNamespace)
//                        .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                       // .zIndex(zIndex(of: playcard))
//                
//            }
//            ForEach(game.allCards.filter(isUndealt)) { card in
//                
//                CardView(card: card)
//                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
//                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
//                    .zIndex(zIndex(of: card))
//            
//        }
//            
//        }
//      
//        .frame(width: CardConstands.undealtWidth, height: CardConstands.undealtHeight)
//        .foregroundColor(CardConstands.color)
//        .onTapGesture {
//          
//            for card in game.cards {
//                withAnimation(dealAnimation(for: card)) {
//                    
//                    deal(card)
//                   
//                }
//            }
//        }
//    }
    
    @ViewBuilder
    var newCards: some View  {
        
        
        Button(action: {
              withAnimation(.linear(duration: 1)) {
            if (game.allCards.count >= 3 && !game.allCards.isEmpty && game.numberOfPlayedCards < 81) {
                if game.haveMatch{
                    game.remove()
                }else{
                    game.threeNewCards()
                }
            }
        }
                }
               ,label: {
            
            if !(game.allCards.count >= 3 && !game.allCards.isEmpty && game.numberOfPlayedCards<81) {
                Text("3 neue Karten").font(.body).foregroundColor(.gray)
            }else{
                Text("3 neue Karten")
            }
        })
        
    }
    
    var newGame: some View  {
        
        Button(action: {
            game.newGame()
        }
               ,label: {
            VStack{
                Text("Neues Spiel").font(.body)
            }
        })
    }
    
    var cheat: some View  {
        
        Button(action: {
            game.cheat()
        }
               ,label: {
            VStack{
                Text("Hilfe").font(.body)
            }
        })
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















































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ViewModel()
        ContentView(game: game)
    }
}
