//
//  viewModel.swift
//  Set
//
//  Created by Anna Rieckmann on 19.10.23.
//

import SwiftUI



class ViewModel: ObservableObject {
    typealias Card = SetGame<String>.Card
  private static let emojis :Array<String> = ["😄","🥰","🐶","🦊","🙈","🦄","🐕","🦭"]
    
   private static func createSetGame () -> SetGame<String> {
        SetGame<String> (number0fPairsOfCards: 8) {pairIndex in emojis[pairIndex]}
    }
    
   @Published private var model: SetGame<String> = createSetGame()
    
    var cards: Array<Card> {
    return model.cards
    }
    
    // MARK: -Intent(s)
    func choose (_ card: Card){
        model.choose(card: card)
    }
    
}
