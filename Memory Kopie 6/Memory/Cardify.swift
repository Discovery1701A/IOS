//
//  Cardify.swift
//  Memory
//
//  Created by Anna Rieckmann on 23.10.23.
//

import SwiftUI
struct Cardify: ViewModifier {
    var isFaceUp: Bool
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if isFaceUp {
                shape.fill().foregroundColor (.white)
                shape.strokeBorder(lineWidth: DrawingConstants.linewidth)
                content
            } else {
                shape.fill()
            }
        }
    }
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let linewidth: CGFloat = 3
    }
}
