//
//  Model.swift
//  Set
//
//  Created by Anna Rieckmann on 19.10.23.
//

import Foundation
struct SetGame<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfShapes> where CardSymbolShape: Hashable, CardSymbolColor: Hashable, CardSymbolPattern: Hashable{
    private (set) var cards: [Card]
    var choosenCards : [Card] = []
    private(set) var totalNumberOfCards: Int
    private var initialNumberOfPlayingCards: Int
    private let createCardSymbol: (Int) -> Card.CardContent
    private(set) var playingCards: [Card]
    private(set) var numberOfPlayedCards = 0
    var score = 0
    
    private var index0fTheOneAndOnlyFaceUpCard: Int?{
        get{playingCards.indices.filter({ playingCards[$0].choosen }).oneAndOnly
        }
        set{playingCards.indices.forEach{ playingCards[$0].choosen = ($0 == newValue) }
        }
    }
        
    mutating func formSet(by cards: [Card]) -> Bool {
        var shapes = Set<CardSymbolShape>()
        var colors = Set<CardSymbolColor>()
        var patterns = Set<CardSymbolPattern>()
        var numberOfShapes = Set<Int>()
        
            cards.forEach { card in
                shapes.insert(card.symbol.shape)
                colors.insert(card.symbol.color)
                patterns.insert(card.symbol.pattern)
                numberOfShapes.insert(card.symbol.numberOfShapes)
            }
            //print(shapes.count)
            if shapes.count == 2 || colors.count == 2 ||
                patterns.count == 2 || numberOfShapes.count == 2 {
                return false
            }
        
        return true
    }
    mutating func choose (card: Card){
        if let chosenIndex = playingCards.firstIndex(where: { $0.id == card.id }){
            
            if !playingCards[chosenIndex].choosen,
            !playingCards[chosenIndex].isMatched
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
                    
                    choosenCards.append(playingCards[chosenIndex])
                    playingCards[chosenIndex].choosen = true
                  
                } else {
                    choosenCards = []
                    // cards[chosenIndex].choosen = false
                    index0fTheOneAndOnlyFaceUpCard = chosenIndex
                }
                
                
                
            }else {
                if choosenCards.count < 3{
                    playingCards[chosenIndex].choosen = false
                    choosenCards.forEach { card in
                        let matchedIndex = choosenCards.firstIndex(of: card)!
                        choosenCards.remove(at: matchedIndex)
                    }
                }
                    
                }
                    }
        //print(choosenCards.count)
        if formSet(by: choosenCards) && choosenCards.count == 3{
            //print("sdvdsv")
            score += 1
            for i in 0 ..< choosenCards.count{
                for j in 0 ..< playingCards.count{
                    if playingCards[j] == choosenCards[i]{
                        playingCards[j].isMatched = true
                        if cards.count>0{
                            playingCards[j] = cards[2-i]
                            if playingCards.count <= 12{
                                cards.remove(at: 2-i)
                                numberOfPlayedCards += 1
                            }
                        }
                    }
                }
            }
        }

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
            self.playingCards = []
            self.cards = []
            
        newGame()
        
        }
    mutating func threeNewCards(){
        if cards.count >= 3 && !cards.isEmpty {
           
            for i in stride(from: 3-1, through: 0, by: -1) {
                
                self.playingCards.append(self.cards[i])
                //print ("id",self.cards[i].id,"i",i)
                self.cards.remove(at: i)
                self.numberOfPlayedCards += 1
            }
        }
       // print(cards.count)
        }
    mutating func newGame(){
        self.score = 0
        self.playingCards = []
        self.cards = []
        self.numberOfPlayedCards = 0
        for i in 0 ..< self.totalNumberOfCards {
            let content = self.createCardSymbol(i)
            let newCard = Card(symbol: content, id: i)
            self.cards.append(newCard)
        }
         self.cards.shuffle()
        for i in stride(from: initialNumberOfPlayingCards-1 , through: 0, by: -1)  {
            
            self.playingCards.append(self.cards[i])
            self.cards.remove(at: i)
            self.numberOfPlayedCards += 1
        
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

