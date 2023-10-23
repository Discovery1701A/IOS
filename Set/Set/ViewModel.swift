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
        var contents = [Card.CardContent]()

        
        for shape in ContentShape.allCases {
            for color in ContentColor.allCases {
                for pattern in ContentPattern.allCases {
                    for numberOfShapes in NumberOfContentShapes.allCases {
                        contents.append(Card.CardContent( shape: shape, color: color, pattern: pattern, numberOfShapes: numberOfShapes.rawValue))
                    }
                }
            }
        }
        
        return contents.shuffled()
    }()
    
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
    // MARK: -Intent(s)
    func choose (_ card: Card){
        model.choose(card: card)
    }
    func threeNewCards(){
        model.threeNewCards()
    }
    enum ContentShape: CaseIterable {
        case oval
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
