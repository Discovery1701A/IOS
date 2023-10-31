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
            
            Text("Sets: " + String(game.score)).font(.largeTitle).padding()
            AspectVGrid(items: game.cards,aspectRatio:2/3, content: {card in
                CardView(card: card)
                    .padding(4)
                    .onTapGesture {
                        game.choose(card)
                    }
            }).foregroundColor(/*@START_MENU_TOKEN@*/.orange/*@END_MENU_TOKEN@*/)
            
            HStack{
                newCards
                Spacer()
                cheat
                Spacer()
                newGame
            }.padding(.horizontal)
//            Text(String(game.cards.count))
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
            if (game.allCards.count >= 3 && !game.allCards.isEmpty && game.numberOfPlayedCards<81) {
                if game.haveMatch{
                    game.remove()
                }else{
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
}















































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ViewModel()
        ContentView(game: game)
    }
}
