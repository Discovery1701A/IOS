//
//  Model.swift
//  Set
//
//  Created by Anna Rieckmann on 19.10.23.
//

import Foundation
struct SetGame<CardContent> where CardContent:
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
        for trippelIndex in 0 ..< number0fPairsOfCards {
            let content: CardContent = createCardContent (trippelIndex)
            cards.append (Card(content: content,id: trippelIndex*3))
            cards.append (Card(content: content, id : trippelIndex*3+1))
            cards.append (Card(content: content, id : trippelIndex*3+2))
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

