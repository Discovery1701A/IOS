//
//  EmojiMemoryGame.swift
//  Memory
//
//  Created by Anna Rieckmann on 02.10.23.
//

import SwiftUI



class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
  private static let emojis :Array<String> = ["😄","🥰","🐶","🦊","🙈","🦄","🐕","🦭"]
    
   private static func createMemoryGame () -> MemoryGame<String> {
        MemoryGame<String> (number0fPairsOfCards: 4) {pairindex in emojis[pairindex]}
    }
    
   @Published private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<Card> {
    return model.cards
    }
    
    // MARK: -Intent(s)
    func choose (_ card: Card){
        model.choose(card: card)
    }
    
}
