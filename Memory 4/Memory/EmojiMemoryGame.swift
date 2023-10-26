//
//  EmojiMemoryGame.swift
//  Memory
//
//  Created by Anna Rieckmann on 02.10.23.
//

import SwiftUI



class EmojiMemoryGame: ObservableObject {
    
    var themen = Themen<String>()
    
    
    @Published private var model: MemoryGame<String>
    private var currentThemeModel: Theme<String>
    init() {
        let currentTheme = Theme<String>(theme: themen.themes.randomElement()!) // zufälliges Themear aus dem Array
        let uniqueContent = themen.returnCardsForGame(theme: currentTheme)  // Array aus dem Thema
        
        model = MemoryGame<String>(numberOfPairsOfCards: themen.returnCardsForGame(theme: currentTheme).count) { pairIndex in
            uniqueContent[pairIndex]
        }
        currentThemeModel = currentTheme
    }
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    func createNewMemoryGame() {
        let currentTheme = Theme<String>(theme: themen.themes.randomElement()!)
        let uniqueContent = themen.returnCardsForGame(theme: currentTheme)
        model = MemoryGame<String>(numberOfPairsOfCards: themen.returnCardsForGame(theme: currentTheme).count) { pairIndex in
            uniqueContent[pairIndex]
        }
        self.shuffle()  // mischen
        currentThemeModel = currentTheme
        
    }
    // MARK: -Intent(s)
    func choose (_ card: MemoryGame<String>.Card){
        model.choose(card: card)
    }
   
    
    func getCardColor() -> Color {
        themen.getCardColor(theme: currentThemeModel)
    }
    func getGroundColor() -> Color {
        themen.getGroundColor(theme: currentThemeModel)
    }
    func getThemeName()->String{
        themen.getThemeName(theme: currentThemeModel)
    }
    
    
    func shuffle() {
        model.shuffle()
    }
    func getScore()->Int {
        return model.getScore()
    }
}
