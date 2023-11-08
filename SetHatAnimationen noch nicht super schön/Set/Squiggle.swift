//
//  Squiggle.swift
//  Set
//
//  Created by Anna Rieckmann on 02.11.23.
//

import SwiftUI

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX - 50, y: rect.midY))
        
        let midX = rect.midX
        let midY = rect.midY
        
        path.move(to: CGPoint(x: midX + 52.0, y: midY - 13.0))
        path.addCurve(to: CGPoint(x: midX + 11.0, y: midY + 25.0),
                      control1: CGPoint(x: midX + 60.4, y: midY + 7.9),
                      control2: CGPoint(x: midX + 37.7, y: midY + 31.8))
        path.addCurve(to: CGPoint(x: midX - 25.0, y: midY + 24.0),
                      control1: CGPoint(x: midX - 0.7, y: midY + 22.3),
                      control2: CGPoint(x: midX - 10.8, y: midY + 13.0))
        path.addCurve(to: CGPoint(x: midX - 47.0, y: midY + 11.0),
                      control1: CGPoint(x: midX - 42.4, y: midY + 36.6),
                      control2: CGPoint(x: midX - 46.6, y: midY + 29.3))
        path.addCurve(to: CGPoint(x: midX - 16.0, y: midY - 17.0),
                      control1: CGPoint(x: midX - 47.4, y: midY - 7.0),
                      control2: CGPoint(x: midX - 32.9, y: midY - 19.3))
        path.addCurve(to: CGPoint(x: midX + 37.0, y: midY - 15.0),
                      control1: CGPoint(x: midX + 7.2, y: midY - 13.8),
                      control2: CGPoint(x: midX + 9.9, y: midY + 2.5))
        path.addCurve(to: CGPoint(x: midX + 52.0, y: midY - 13.0),
                      control1: CGPoint(x: midX + 43.3, y: midY - 19.0),
                      control2: CGPoint(x: midX + 48.9, y: midY - 22.1))
        
        
        let pathRect = path.boundingRect
        path = path.offsetBy(dx: rect.minX - pathRect.minX, dy: rect.minY - pathRect.minY)
        
        let scale: CGFloat = rect.width / pathRect.width
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        path = path.applying(transform)
        
        
        return path
        //.offsetBy(dx: rect.minX - path.boundingRect.minX, dy: rect.midY - path.boundingRect.midY)
    }
}
