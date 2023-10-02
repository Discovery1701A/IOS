//
//  EmojiMemoryGame.swift
//  Memory
//
//  Created by Anna Rieckmann on 02.10.23.
//

import SwiftUI



class EmojiMemoryGame {
  static let emojis :Array<String> = ["😄","🥰","🐶","🦊","🙈","🦄","🐕","🦭"]
    
    static func createMemoryGame () -> MemoryGame<String> {
        MemoryGame<String> (number0fPairsOfCards: 4) {pairindex in emojis[pairindex]}
    }
    
    private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
    return model.cards
    }
}
