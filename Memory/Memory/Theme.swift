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
    let groundColor: String
    var numberOfPairs: Int
    
    func returnCardsForGame() -> [Cards] {
        let shuffledCards = cardSet.shuffled()
        var RandomCardsForGame: Array<Cards> = []
        if numberOfPairs <= cardSet.count{
            for pairIndex in 0..<numberOfPairs {
                RandomCardsForGame.append(shuffledCards[pairIndex])
            }
        }else{
            RandomCardsForGame = shuffledCards
        }
        return RandomCardsForGame
    }
    
    init (theme: Theme<Cards>) {
        self.numberOfPairs = theme.numberOfPairs
        self.cardSet = theme.cardSet
        self.themeColor = theme.themeColor
        self.themeName = theme.themeName
        self.groundColor = theme.groundColor
    }
    
    init(cardSet: [Cards], numberOfPairs: Int, themeColor: String, themeName: String, groundColor: String) {
         
        self.numberOfPairs = numberOfPairs
        self.cardSet = cardSet
        self.themeColor = themeColor
        self.themeName = themeName
        self.groundColor = groundColor
           
       }
}
