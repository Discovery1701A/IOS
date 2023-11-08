//
//  ContentView.swift
//  Set
//
//  Created by Anna Rieckmann on 19.10.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game : ViewModel
    
    var body: some View {
        VStack{
            cardView()
        }
    }
    
    @ViewBuilder
    private func cardView()-> some View{
        if  game.setAvailableInPlayedCards || game.setAvailableInAllCards{
            
            Text("Sets: " + String(game.score))
                .font(.largeTitle)
                .padding()
            AspectVGrid(items: game.cards,aspectRatio:2/3, content: {card in
                
                CardView(card: card)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .padding(4)
                    .onTapGesture {
                        withAnimation(.linear(duration: 1)) {
                            game.choose(card)
                        }
                    }
            })
            .foregroundColor(/*@START_MENU_TOKEN@*/.orange/*@END_MENU_TOKEN@*/)
            
            HStack{
                newCards
                Spacer()
                cheat
                Spacer()
                newGame
            }
            .padding(.horizontal)
           // Text(String(game.allCards.count))
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
    
    @ViewBuilder
    var newCards: some View  {
        Button(action: {
            withAnimation(.linear(duration: 1)) {
                if (game.allCards.count >= 3 && !game.allCards.isEmpty && game.numberOfPlayedCards < 81) {
                    game.threeNewCards()
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
                Text("Neues Spiel")
                    .font(.body)
        })
    }
    
    var cheat: some View  {
        Button(action: {
            game.cheat()
        }
               ,label: {
                Text("Hilfe")
                    .font(.body)
        })
    }
}















































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ViewModel()
        ContentView(game: game)
    }
}
