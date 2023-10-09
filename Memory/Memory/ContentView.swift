//
//  ContentView.swift
//  Memory
//
//  Created by Anna Rieckmann on 21.09.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel : EmojiMemoryGame
    
    var body: some View {
        VStack{
            ScrollView{
        LazyVGrid(columns: [GridItem(.adaptive (minimum: 65))], content: {
            
            ForEach(viewModel.cards, content:
                        {card in
                CardView(card: card).aspectRatio(2/3, contentMode: .fit)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            })
        }).foregroundColor(/*@START_MENU_TOKEN@*/.orange/*@END_MENU_TOKEN@*/)
    }

        }
        .padding(.horizontal)
            }
    
}


struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        
        ZStack{
            let shape :RoundedRectangle = RoundedRectangle (cornerRadius: 20.0)
            if card.isFaceUp{
                
                    shape.fill()
                    shape.foregroundColor(.white)
                RoundedRectangle (cornerRadius: 20.0)
                    .strokeBorder(lineWidth: 3.0)
                Text(card.content)
                    .font(.largeTitle)
            }else if card.isMatched {
                shape.opacity(0)
            }else{
                
               
                    shape.fill()
            }
        }
    }
}































let game = EmojiMemoryGame() // muss auserhalb sein sonst gibt es einen Error (Ambiguous use of 'init(_:traits:body:)')
#Preview {
    
    ContentView(viewModel: game)
}
