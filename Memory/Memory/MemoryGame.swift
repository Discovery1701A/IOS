//
//  MemoryGame.swift
//  Memory
//
//  Created by Anna Rieckmann on 02.10.23.
//

import Foundation
struct MemoryGame<CardContent>{
    private (set) var cards: Array <Card>
    
    func choose (card: Card){
        
    }
    init (number0fPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
    cards = Array<Card> ()
        for pairIndex in 0 ..< number0fPairsOfCards {
            let content: CardContent = createCardContent (pairIndex)
            cards.append (Card(content: content))
            cards.append (Card(content: content))
        }
    // add number0fPairsOfCards × 2 cards to cards array
    }
    
    struct Card {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
  
    }
}
