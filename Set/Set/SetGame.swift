//
//  Model.swift
//  Set
//
//  Created by Anna Rieckmann on 19.10.23.
//

import Foundation
struct SetGame<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfShapes> where CardSymbolShape: Hashable, CardSymbolColor: Hashable, CardSymbolPattern: Hashable{
    private (set) var cards: Array <Card>
    var choosenCards : [Card] = []
    private(set) var totalNumberOfCards: Int
    private var initialNumberOfPlayingCards: Int
    private let createCardSymbol: (Int) -> Card.CardContent
    private(set) var playingCards: [Card]
    private(set) var numberOfPlayedCards = 0
    
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
    
    
    init(initialNumberOfPlayingCards: Int, totalNumberOfCards: Int, createCardContent: @escaping (Int) -> Card.CardContent) {
            self.initialNumberOfPlayingCards = initialNumberOfPlayingCards
            self.totalNumberOfCards = totalNumberOfCards
            self.createCardSymbol = createCardContent
            self.playingCards = [] // Initialize playingCards here
            self.cards = [] // Initialize cards array here
            for _ in 0..<initialNumberOfPlayingCards {
                let content = createCardContent(numberOfPlayedCards)
                let newCard = Card(symbol: content, id: numberOfPlayedCards)
                self.playingCards.append(newCard)
                self.cards.append(newCard) // Add the new card to the cards array
                numberOfPlayedCards += 1
            }
        }
    
    struct Card :Identifiable, Equatable{
        var choosen: Bool = false
        var isMatched: Bool = false
        let symbol: CardContent
        let id : Int
        struct CardContent {
            let shape: CardSymbolShape
            let color: CardSymbolColor
            let pattern: CardSymbolPattern
            let numberOfShapes: Int
        }
        static func == (lhs: SetGame<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfShapes>.Card, rhs: SetGame<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfShapes>.Card) -> Bool {
            lhs.id == rhs.id
        }
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

