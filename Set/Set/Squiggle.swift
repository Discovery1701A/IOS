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

                let controlPoint1 = CGPoint(x: rect.midX - 25, y: rect.midY - 50)
                let controlPoint2 = CGPoint(x: rect.midX, y: rect.midY + 25)
                let endPoint1 = CGPoint(x: rect.midX + 25, y: rect.midY - 50)

                let controlPoint3 = CGPoint(x: rect.midX + 50, y: rect.midY - 25)
                let controlPoint4 = CGPoint(x: rect.midX, y: rect.midY + 50)
                let endPoint2 = CGPoint(x: rect.midX - 25, y: rect.midY + 50)

                let controlPoint5 = CGPoint(x: rect.midX - 50, y: rect.midY + 25)
                let controlPoint6 = CGPoint(x: rect.midX, y: rect.midY - 50)
                let endPoint3 = CGPoint(x: rect.midX + 25, y: rect.midY + 50)

                let controlPoint7 = CGPoint(x: rect.midX + 50, y: rect.midY - 25)
                let controlPoint8 = CGPoint(x: rect.midX, y: rect.midY + 25)
                let endPoint4 = CGPoint(x: rect.midX - 25, y: rect.midY - 50)

                path.addCurve(to: endPoint1, control1: controlPoint1, control2: controlPoint2)
                path.addCurve(to: endPoint2, control1: controlPoint3, control2: controlPoint4)
                path.addCurve(to: endPoint3, control1: controlPoint5, control2: controlPoint6)
                path.addCurve(to: endPoint4, control1: controlPoint7, control2: controlPoint8)

        

        let pathRect = path.boundingRect
        path = path.offsetBy(dx: rect.minX - pathRect.minX, dy: rect.minY - pathRect.minY)
        
        let scale: CGFloat = rect.width / pathRect.width
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        path = path.applying(transform)
        
        
        return path
          //  .offsetBy(dx: rect.minX - path.boundingRect.minX, dy: rect.midY - path.boundingRect.midY)
    }
}
