//
//  MemoryGame.swift
//  Memory
//
//  Created by Anna Rieckmann on 02.10.23.
//

import Foundation
struct MemoryGame<CardContent>{
    var cards: Array <Card>
    
    func choose (card: Card){
        
    }
    struct Card {
        var isFaceUp: Bool
        var isMatched: Bool
        var content: CardContent
  
    }
}
