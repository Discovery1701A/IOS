//
//  viewModel.swift
//  Set
//
//  Created by Anna Rieckmann on 19.10.23.
//

import SwiftUI



class viewModel: ObservableObject {
    typealias Card = SetGame<String>.Card
  private static let emojis :Array<String> = ["😄","🥰","🐶","🦊","🙈","🦄","🐕","🦭"]
    
   private static func createMemoryGame () -> SetGame<String> {
        SetGame<String> (number0fPairsOfCards: 4) {pairindex in emojis[pairindex]}
    }
    
   @Published private var model: SetGame<String> = createMemoryGame()
    
    var cards: Array<Card> {
    return model.cards
    }
    
    // MARK: -Intent(s)
    func choose (_ card: Card){
        model.choose(card: card)
    }
    
}
