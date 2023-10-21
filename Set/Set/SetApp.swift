//
//  SetApp.swift
//  Set
//
//  Created by Anna Rieckmann on 19.10.23.
//

import SwiftUI

@main
struct SetApp: App {
    private let game = ViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(game: game)
        }
    }
}
