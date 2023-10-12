//
//  EmojiMemoryGame.swift
//  Memory
//
//  Created by Anna Rieckmann on 02.10.23.
//

import SwiftUI



class EmojiMemoryGame: ObservableObject {

    
    
    
    @Published private var model: MemoryGame<String>
    @Published private var currentThemeModel: Theme<String>
    init() {
           let currentTheme = Theme<String>(theme: themes.randomElement()!)
        let uniqueContent = currentTheme.returnCardsForGame()

           model = MemoryGame<String>(numberOfPairsOfCards: currentTheme.returnCardsForGame().count) { pairIndex in
               uniqueContent[pairIndex]
           }
           currentThemeModel = currentTheme
       }
    var cards: Array<MemoryGame<String>.Card> {
    return model.cards
    }
    func createNewMemoryGame() {
        let currentTheme = Theme<String>(theme: themes.randomElement()!)
        let uniqueContent = currentTheme.returnCardsForGame()
        model = MemoryGame<String>(numberOfPairsOfCards: currentTheme.returnCardsForGame().count) { pairIndex in
                uniqueContent[pairIndex]
            }
        self.shuffle()
        currentThemeModel = currentTheme
           
        }
    // MARK: -Intent(s)
    func choose (_ card: MemoryGame<String>.Card){
        model.choose(card: card)
    }
    private var themes = [
           Theme<String>(cardSet: ["👻","🎃","🕷","🧟‍♂️","🧛🏼‍♀️","☠️","👽","🦹‍♀️","🦇","🌘","⚰️","🔮"],
                         numberOfPairs: 12,
                         themeColor: "orange",
                         themeName: "Halloween",
                         groundColor: "black"),
           
           Theme<String>(cardSet: ["🥭","🍒","🍈","🫐","🍇","🍉","🍓","🍊","🍋","🍌","🍐","🍏"],
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
    func getCardColor() -> Color {
            switch currentThemeModel.themeColor {
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
    func getGroundColor() -> Color {
            switch currentThemeModel.groundColor {
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
    func getThemeName()->String{
        return currentThemeModel.themeName
    }
    
    
    func shuffle() {
            model.shuffle()
        }
    func getScore()->Int {
        return model.getScore()
    }
}
