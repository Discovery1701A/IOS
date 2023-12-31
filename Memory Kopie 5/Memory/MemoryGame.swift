//
//  MemoryGame.swift
//  Memory
//
//  Created by Anna Rieckmann on 02.10.23.
//

import Foundation
struct MemoryGame<CardContent> where CardContent:
Equatable {
    private (set) var cards: Array <Card>
    private var index0fTheOneAndOnlyFaceUpCard: Int?{
        get{cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly
        }
        set{cards.indices.forEach{ cards[$0].isFaceUp = ($0 == newValue) }
        }
    }
        
        
    mutating func choose (card: Card){
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
            !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = index0fTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                
                index0fTheOneAndOnlyFaceUpCard = chosenIndex
            }
            
           
        }
    }
   
    init (number0fPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
    cards = Array<Card> ()
        for pairIndex in 0 ..< number0fPairsOfCards {
            let content: CardContent = createCardContent (pairIndex)
            cards.append (Card(content: content,id: pairIndex*2))
            cards.append (Card(content: content, id : pairIndex*2+1))
        }
    // add number0fPairsOfCards × 2 cards to cards array
    }
    
    struct Card :Identifiable{
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        let content: CardContent
        let id : Int
    }
}
extension Array {
    var oneAndOnly: Element? {
        if self.count == 1 {
            return self.first
        } else {
            return nil
        }
    }
}
