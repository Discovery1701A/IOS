//
//  ContentView.swift
//  kurven
//
//  Created by Anna Rieckmann on 02.11.23.
//

import SwiftUI

struct Squiggle: Shape {
    var controlPoints: [CGPoint]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard controlPoints.count >= 3 else { return path }
        
        path.move(to: controlPoints[0])

        var index = 1
        while index < controlPoints.count {
            let endPoint = controlPoints[index]
            let controlPoint1 = controlPoints[(index + 1) % controlPoints.count]
            let controlPoint2 = controlPoints[(index + 2) % controlPoints.count]
            path.addCurve(to: endPoint, control1: controlPoint1, control2: controlPoint2)
            index += 3
        }
        path.closeSubpath()

        return path
    }
}

struct SquiggleView: View {
    @State private var controlPoints: [CGPoint] = [
        CGPoint(x: 50, y: 150),
        CGPoint(x: 150, y: 150),
        CGPoint(x: 100, y: 50),
        CGPoint(x: 200, y: 50),
        CGPoint(x: 250, y: 150),
        CGPoint(x: 350, y: 150),
    ]

    var body: some View {
        Squiggle(controlPoints: controlPoints)
            .stroke(Color.black, lineWidth: 3)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if let draggedIndex = nearestControlPointIndex(to: gesture.location) {
                            controlPoints[draggedIndex] = gesture.location
                        }
                    }
            )
    }

    private func nearestControlPointIndex(to point: CGPoint) -> Int? {
        let tolerance: CGFloat = 30.0
        for (index, controlPoint) in controlPoints.enumerated() {
            if abs(controlPoint.x - point.x) < tolerance && abs(controlPoint.y - point.y) < tolerance {
                return index
            }
        }
        return nil
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            SquiggleView()
        }
    }
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
