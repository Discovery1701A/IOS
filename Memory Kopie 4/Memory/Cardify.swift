//
//  Cardify.swift
//  Memory
//
//  Created by Anna Rieckmann on 23.10.23.
//

import SwiftUI
struct Cardify: AnimatableModifier {
    init (isFaceUp: Bool){
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double{
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double // degrees
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor (.white)
                shape.strokeBorder(lineWidth: DrawingConstants.linewidth)
               
            } else {
                shape.fill()
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(
            Angle.degrees(rotation),
                                  axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/
        )
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let linewidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
