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
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    private(set) var score: Int = 0
    mutating func choose (card: Card){
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                cards[potentialMatchIndex].alreadySeeCount += 1
                cards[chosenIndex].alreadySeeCount += 1
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                }else if cards[chosenIndex].alreadySeeCount > 1 && cards[potentialMatchIndex].alreadySeeCount > 1  // -2 wenn die karten schon mal beide gesehen wurden
                {
                    score -= 2
                    
                } else if cards[chosenIndex].alreadySeeCount > 1 || cards[potentialMatchIndex].alreadySeeCount > 1 {
                    
                    score -= 1
                }
                
                indexOfTheOneAndOnlyFaceUpCard = nil
            }
            else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
           
        }
    }
    
    init (numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card> ()
        for pairIndex in 0 ..< numberOfPairsOfCards {
            let content: CardContent = createCardContent (pairIndex)
            cards.append (Card(content: content,id: pairIndex*2))
            cards.append (Card(content: content, id : pairIndex*2+1))
        }
        cards.shuffle()
        score = 0
        // add number0fPairsOfCards × 2 cards to cards array
    }
    
    struct Card :Identifiable{
        var alreadySeeCount = 0  // Schon mal gesehen
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id : Int
    }
    mutating func shuffle() {
        cards.shuffle()
    }
    func getScore ()->Int{
        return self.score
    }
}
