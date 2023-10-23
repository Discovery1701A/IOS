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
            AspectVGrid(items: game.cards,aspectRatio:2/3, content: {card in
                cardView(for: card)
            })
            .foregroundColor(/*@START_MENU_TOKEN@*/.orange/*@END_MENU_TOKEN@*/)
            .padding(.horizontal)
            HStack{
                newCards
                Spacer()
                newGame
            }.padding(.horizontal)
        }
        
    }
    @ViewBuilder
    private func cardView(for card :ViewModel.Card)-> some View{
        if card.isMatched && !card.choosen{
            Rectangle().opacity(0)
        }else{
            CardView(card: card)
                .padding(4)
                .onTapGesture {
                    game.choose(card)
                }}
    }
    @ViewBuilder
    var newCards: some View  {
        if (game.allCards.count >= 3 && !game.allCards.isEmpty && game.numberOfPlayedCards<81) {
            Button(action: {
                
                game.threeNewCards()
                
            }
                   ,label: {
            
                    Text("3 neue Karten")
                 
                    
                        .font(.body)
                
            })
            
        }
    }
    var newGame: some View  {
        
            Button(action: {
                
                game.newGame()
                
            }
                   ,label: {
                VStack{
                    Text("Neues Spiel")
                   
                    
                        .font(.body)
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
