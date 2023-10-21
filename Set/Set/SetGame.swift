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
    var choosenCards : [Card] = []
    private var index0fTheOneAndOnlyFaceUpCard: Int?{
        get{cards.indices.filter({ cards[$0].choosen }).oneAndOnly
        }
        set{cards.indices.forEach{ cards[$0].choosen = ($0 == newValue) }
        }
    }
        
        
    mutating func choose (card: Card){
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }){
            if !cards[chosenIndex].choosen,
            !cards[chosenIndex].isMatched
            {
                
                //  if let potentialMatchIndex = index0fTheOneAndOnlyFaceUpCard {
                //if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                //  cards[chosenIndex].isMatched = true
                // cards[potentialMatchIndex].isMatched = true
                // }
                if choosenCards.count >= 3{
                    choosenCards = []
                    //cards[chosenIndex].choosen = false
                    index0fTheOneAndOnlyFaceUpCard = chosenIndex
                }
                if choosenCards.count < 3{
                    choosenCards.append(cards[chosenIndex])
                    cards[chosenIndex].choosen = true
                    
                } else {
                    choosenCards = []
                    // cards[chosenIndex].choosen = false
                    index0fTheOneAndOnlyFaceUpCard = chosenIndex
                }
                
                
                
            }else {
                if choosenCards.count < 3{
                    cards[chosenIndex].choosen = false
                    choosenCards.forEach { card in
                        let matchedIndex = choosenCards.firstIndex(of: card)!
                        choosenCards.remove(at: matchedIndex)
                    }
                }
                    
                }
        }
        print(choosenCards.count)
    }
   // func match (){
      //  if chosenCards.count == 3 {
        //    chosenCards.forEach { card in
                
         //   }
   // }
    
    
    init (number0fPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card> ().shuffled()
        for trippelIndex in 0 ..< number0fPairsOfCards {
            let content: CardContent = createCardContent (trippelIndex)
            cards.append (Card(content: content,id: trippelIndex*3))
            cards.append (Card(content: content, id : trippelIndex*3+1))
            cards.append (Card(content: content, id : trippelIndex*3+2))
        }
        cards.shuffle()
    // add number0fPairsOfCards × 2 cards to cards array
    }
    
    struct Card :Identifiable, Equatable{
        var choosen: Bool = false
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

