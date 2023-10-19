//
//  ContentView.swift
//  Set
//
//  Created by Anna Rieckmann on 19.10.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game : viewModel
    var body: some View {
      
        AspectVGrid(items: game.cards,aspectRatio:2/3, content: {card in
            cardView(for: card)
        })
            .foregroundColor(/*@START_MENU_TOKEN@*/.orange/*@END_MENU_TOKEN@*/)
            .padding(.horizontal)
            }
    @ViewBuilder
    private func cardView(for card :viewModel.Card)-> some View{
        if card.isMatched && !card.choosen{
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
    let card: viewModel.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                let shape :RoundedRectangle = RoundedRectangle (cornerRadius: DrawingConstants.cornerRadius)
               
                    
                    shape.fill()
                    shape.foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Text (card.content).font(font (in: geometry.size))
                       
                if card.choosen {
                    shape.strokeBorder(lineWidth: 5)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
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
































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = viewModel()
        ContentView(game: game)
    }
}
