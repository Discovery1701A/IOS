//
//  viewModel.swift
//  Set
//
//  Created by Anna Rieckmann on 19.10.23.
//

import SwiftUI


class ViewModel: ObservableObject {
    
    typealias Card = SetGame<ContentShape, ContentColor, ContentPattern, NumberOfContentShapes>.Card
    
    static var cardContents: [Card.CardContent] = {
        // geht alle möglichkeiten durch wegen enum und transformiert zu einem Array [1,0:]
        return ContentShape.allCases.flatMap { shape in
            ContentColor.allCases.flatMap { color in
                ContentPattern.allCases.flatMap { pattern in
                    NumberOfContentShapes.allCases.compactMap { numberOfShapes in
                        Card.CardContent(shape: shape, color: color, pattern: pattern, numberOfShapes: numberOfShapes.rawValue)
                    }
                }
            }
        }.shuffled()
    }() // Closure sollte ja drin sein
    
    private static func createSetGame () -> SetGame<ContentShape, ContentColor, ContentPattern, NumberOfContentShapes> {
        SetGame(initialNumberOfPlayingCards: 12, totalNumberOfCards: cardContents.count) { cardContents[$0] }
    }
    
    @Published private var model: SetGame<ContentShape, ContentColor, ContentPattern, NumberOfContentShapes> = createSetGame()
    
    var cards: Array<Card> {
        return model.playingCards
    }
    
    var allCards: Array<Card> {
        return model.cards
    }
    
    var numberOfPlayedCards: Int{
        return model.numberOfPlayedCards
    }
    
    var score : Int{
        return model.score
    }
    
    var setAvailableInAllCards : Bool{
        return model.setAvailableInAllCards
    }
    
    var setAvailableInPlayedCards : Bool{
        return model.setAvailableInPlayedCards
    }
    
    // MARK: -Intent(s)
    
    func choose (_ card: Card){
        model.choose(card: card)
    }
    
    func threeNewCards(){
        model.threeNewCards()
    }
    
    func newGame(){
        model.newGame()
    }
    
    enum ContentShape: CaseIterable {
        case bean
        case diamond
        case rect
    }
    
    enum ContentColor: CaseIterable {
        case red
        case green
        case blue
        
        func getColor() -> Color {
            switch self {
            case .red:
                return Color.red
            case .green:
                return Color.green
            case .blue:
                return Color.blue
            }
        }
    }
    
    enum ContentPattern: CaseIterable {
        case filled
        case halftransperyt
        case transpery
    }
    
    enum NumberOfContentShapes: Int, CaseIterable {
        case one = 1
        case two = 2
        case three = 3
    }
}
