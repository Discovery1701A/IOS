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
            Spacer()
            newCards
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
    var newCards: some View  {
        Button(action: {
            
        },label: {
            Text("3 neue Karten")
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
