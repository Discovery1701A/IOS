//
//  Theme.swift
//  Memory
//
//  Created by Anna Rieckmann on 10.10.23.
//

import Foundation
import SwiftUI
struct Theme <Cards> {
    let themeName: String
    let cardSet: [Cards]
    let themeColor: String
    let groundColor: String
    var numberOfPairs: Int
    
    
    
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
class Themen<Cards>{
    
    var themes = [
        Theme<String>(cardSet: ["🧛🏼‍♀️","☠️","🧟‍♂️","⚰️","🔮","👻","🎃","👽","🦹‍♀️","🦇","🌘","🕷"],
                      numberOfPairs: 12,
                      themeColor: "orange",
                      themeName: "Halloween",
                      groundColor: "black"),
        
        Theme<String>(cardSet: ["🍉","🍐","🍓","🍊","🍋","🍌","🥭","🍒","🍈","🫐","🍇","🍏"],
                      numberOfPairs: 6,
                      themeColor: "red",
                      themeName: "Obst",
                      groundColor: "green"),
        
        Theme<String>(cardSet: ["😀","😃","😄","😁","😆","🥰","😘","😍","🤪","🫡","🫠","🙄","😲","🤕","🥴"],
                      numberOfPairs: 40,
                      themeColor: "yellow",
                      themeName: "Gefühle",
                      groundColor: "blue"),
        
        Theme<String>(cardSet: ["🐶","🐱","🐭","🐹","🐰","🐨","🐻‍❄️","🐼","🐻","🦊"],
                      numberOfPairs: 10,
                      themeColor: "blue",
                      themeName: "Tiere",
                      groundColor: "yellow"),
        
        Theme<String>(cardSet: ["🥐","🥯","🍞","🥖","🥨","🧀","🥚","🍳","🧈","🥞","🧇","🍖","🍟","🍕","🍔","🥙","🥪","🌭","🌮","🌯","🥘","🥗","🫔","🍝","🥮"],
                      numberOfPairs: 14,
                      themeColor: "purple",
                      themeName: "Essen",
                      groundColor: "orange"),
        
        Theme<String>(cardSet: ["⚽️","🏀","🏈","⚾️","🥎","🎾","🏐","🏉","🥏","🎱","🪀","🏓","🏸","🏒","🏑"],
                      numberOfPairs: 17,
                      themeColor: "gray",
                      themeName: "Sport",
                      groundColor: "blue")
    ]
    func returnCardsForGame(theme: Theme<Cards>) -> [Cards] {
        let shuffledCards = theme.cardSet.shuffled()  // mischen des Themen Cards Set
        var RandomCardsForGame: Array<Cards> = []
        if theme.numberOfPairs <= theme.cardSet.count{  // neues Array mit sovielen Cards füllen wie numberOfPairs ist
            for pairIndex in 0..<theme.numberOfPairs {
                RandomCardsForGame.append(shuffledCards[pairIndex])
            }
        }else{
            RandomCardsForGame = shuffledCards  // ganzes Array wenn numberOfPairs größer als das eigentliche Array ist
        }
        return RandomCardsForGame
    }
    func getColor(colorString : String) -> Color {  // String Farbe zu Color
        switch colorString {
        case "red":
            return .red
        case "orange":
            return .orange
        case "green":
            return .green
        case "blue":
            return .blue
        case "gray":
            return .gray
        case "purple":
            return .purple
        case "yellow":
            return .yellow
        case "black":
            return .black
        default:
            return .red
        }
    }
    func getCardColor(theme: Theme<Cards>) -> Color {
        getColor(colorString: theme.themeColor)
    }
    func getGroundColor(theme: Theme<Cards>) -> Color {
        getColor(colorString: theme.groundColor)
    }
    func getThemeName(theme: Theme<Cards>)->String{
        return theme.themeName
    }
}
