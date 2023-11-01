//
//  Model.swift
//  Set
//
//  Created by Anna Rieckmann on 19.10.23.
//

import Foundation

struct SetGame<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfShapes> where CardSymbolShape: Hashable, CardSymbolColor: Hashable, CardSymbolPattern: Hashable{
    
    private let createCardSymbol: (Int) -> Card.CardContent
    private(set) var cards: [Card]
    private(set) var choosenCards : [Card] = []
    private(set) var potentialSet  : [Card] = []
    private(set) var totalNumberOfCards: Int
    private(set) var initialNumberOfPlayingCards: Int
    private(set) var playingCards: [Card]
    private(set) var numberOfPlayedCards = 0
    private(set) var score = 0
    private(set) var setAvailableInAllCards : Bool = true
    private(set) var setAvailableInPlayedCards : Bool = true
    private(set) var haveMatch : Bool = false
    
    private var index0fTheCard: Int?{
        get{playingCards.indices.filter({ playingCards[$0].choosen }).oneAndOnly
        }
        
        set{playingCards.indices.forEach{ playingCards[$0].choosen = ($0 == newValue) }
        }
    }
    
    init(initialNumberOfPlayingCards: Int, totalNumberOfCards: Int, createCardContent: @escaping (Int) -> Card.CardContent) {
        self.initialNumberOfPlayingCards = initialNumberOfPlayingCards
        self.totalNumberOfCards = totalNumberOfCards
        self.createCardSymbol = createCardContent
        self.playingCards = []
        self.cards = []
        newGame()
    }
    
    public mutating func matchingSet(by cards: [Card]) -> Bool {
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
    
    mutating func checkForSet(by cards: [Card] ) -> Bool {
        if cards.count > 0{
            for i in 0..<cards.count - 2 {
                for j in i+1..<cards.count - 1 {
                    for k in j+1..<cards.count {
                        self.potentialSet = [cards[i], cards[j], cards[k]]
                        if matchingSet(by: self.potentialSet) {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    mutating func remove() {
        if matchingSet(by: self.choosenCards) && self.choosenCards.count == 3{
            for i in stride(from:2  , through: 0, by: -1){
                for j in stride(from:self.playingCards.count-1  , through: 0, by: -1){
                    if self.playingCards[j].isMatched{
                        if self.choosenCards[i] == self.playingCards[j]{
                            if self.playingCards.count <= 12 && self.cards.count>0{
                                
                                self.playingCards[j] = cards[i]
                                self.cards.remove(at: i)
                                self.numberOfPlayedCards += 1
                               // print("conut" + String(cards.count))
                                
                            }
                        } else if self.playingCards.count > 12 || self.cards.count <= 0
                        {
                            self.playingCards.remove(at: j)
                        }
                    }
                }
            }
            choosenCards = []
            self.haveMatch = false
           
        }
    
    }
    
    mutating func choose (card: Card){
        if let chosenIndex = self.playingCards.firstIndex(where: { $0.id == card.id }){
           
            
            if !self.haveMatch && !self.playingCards[chosenIndex].choosen,
               !self.playingCards[chosenIndex].isMatched
            {
                
                if self.choosenCards.count >= 3{
                    self.choosenCards = []
                    for j in 0 ..< self.playingCards.count{
                        if self.playingCards[j].choosen{
                            self.playingCards[j].notMatched = false
                        }
                    }
                    self.haveMatch = false
                    self.index0fTheCard = chosenIndex
                }
               
                if self.choosenCards.count < 3{
                    
                    self.choosenCards.append(self.playingCards[chosenIndex])
                    self.playingCards[chosenIndex].choosen = true
                    
                } else {
                    self.choosenCards = []
                    // cards[chosenIndex].choosen = false
                    self.index0fTheCard = chosenIndex
                }
            } else {
                if self.choosenCards.count < 3{
                    self.playingCards[chosenIndex].choosen = false
                    self.choosenCards.forEach { card in
                        let matchedIndex = self.choosenCards.firstIndex(of: card)!
                        self.choosenCards.remove(at: matchedIndex)
                    }
                }
                remove()
            }
           
            
        }
        
        //print(choosenCards.count)
        if matchingSet(by: self.choosenCards) && self.choosenCards.count == 3{
            //print("sdvdsv")
            self.score += 1
            
            for j in 0 ..< self.playingCards.count{
                    if self.playingCards[j].choosen{
                        self.playingCards[j].isMatched = true
                }
            }
            self.haveMatch = true
        }else if  !matchingSet(by: self.choosenCards) && self.choosenCards.count == 3{
            for j in 0 ..< self.playingCards.count{
                if self.playingCards[j].choosen{
                    self.playingCards[j].notMatched = true
            }
        }
        }
        
        self.setAvailableInAllCards =  checkForSet(by: self.cards + self.playingCards)
        self.setAvailableInPlayedCards = checkForSet(by: self.playingCards)
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
    
    mutating func cheat(){
        if checkForSet(by: playingCards){
            for i in 0 ..< self.potentialSet.count{
                for j in stride(from:self.playingCards.count-1  , through: 0, by: -1){
                    if self.playingCards[j] == self.potentialSet[i]{
                        self.playingCards[j].isMaybeASet = true
                    }
                }
            }
        }else {
            for j in 0 ..< self.playingCards.count{
                self.playingCards[j].isMaybeASet = false
            }
        }
    }
    
    
    mutating func newGame(){
        self.score = 0
        self.playingCards = []
        self.cards = []
        self.numberOfPlayedCards = 0
        self.setAvailableInAllCards = true
        self.setAvailableInPlayedCards = true
        
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
        var notMatched: Bool = false
        var isMaybeASet : Bool = false
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
