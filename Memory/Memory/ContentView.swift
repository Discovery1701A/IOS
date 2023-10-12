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
            Text(viewModel.getThemeName())
                .font(.largeTitle)
            
            HStack{
            Text("Score:")
                Text (String(viewModel.getScore()))
            }
            ScrollView{
        LazyVGrid(columns: [GridItem(.adaptive (minimum: 65))], content: {
            
            ForEach(viewModel.cards, content:
                        {card in
                CardView(card: card,color: viewModel.getGroundColor()).aspectRatio(2/3, contentMode: .fit)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            })
        }).foregroundColor(viewModel.getCardColor())
    }
            Spacer()
            // Buttons
            HStack{
                bdscutton
                Spacer()
                shuffle
            }
        }
        .padding(.horizontal)
            }
    
  
    var bdscutton :some View {
        Button(action: {
            viewModel.createNewMemoryGame()}
               , label: {
            VStack{
                Image(systemName:  "gamecontroller").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Text("New Game")}})
    }
    var shuffle: some View {
        Button(action: {
            viewModel.shuffle()}
               , label: {
            VStack{
                Image(systemName: "shuffle.circle").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Text("mischen")}})
    }
}



struct CardView: View {
    var card: MemoryGame<String>.Card
    let color: Color
    var body: some View {
        
        ZStack{
            let shape :RoundedRectangle = RoundedRectangle (cornerRadius: 20.0)
            if card.isFaceUp{
                
                    shape.fill()
                shape.foregroundColor(color)
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
