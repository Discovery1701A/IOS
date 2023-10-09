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
    private var index0fTheOneAndOnlyFaceUpCard: Int?
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
                index0fTheOneAndOnlyFaceUpCard = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                index0fTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
            print("\(cards)")
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
        var content: CardContent
        var id : Int
    }
}
