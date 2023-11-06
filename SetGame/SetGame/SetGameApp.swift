//
//  SetGameApp.swift
//  SetGame
//
//  Created by Anna Rieckmann on 06.11.23.
//

import SwiftUI

@main
struct SetGameApp: App {
    var body: some Scene {
        let game = ViewModel()
        WindowGroup {
            ContentView(game: game)
        }
    }
}
