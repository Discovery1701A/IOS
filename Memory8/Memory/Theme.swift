//
//  Theme.swift
//  Memory
//
//  Created by Anna Rieckmann on 10.10.23.
//

import Foundation


struct Theme <Cards> {
    let themeName: String
    let cardSet: [Cards]
    let themeColor: String
    var numberOfPairs: Int
    
    func returnCardsForGame() -> [Cards] {
            let shuffledCards = cardSet.shuffled()
            var RandomCardsForGame: Array<Cards> = []
            for pairIndex in 0..<numberOfPairs {
                RandomCardsForGame.append(shuffledCards[pairIndex])
            }
            return RandomCardsForGame
        }
    init(cardSet: [Cards], numberOfPairs: Int, themeColor: String, themeName: String) {
         
        self.numberOfPairs = numberOfPairs
        self.cardSet = cardSet
        self.themeColor = themeColor
        self.themeName = themeName
           
       }
}
