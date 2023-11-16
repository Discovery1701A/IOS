//
//  SetGame2App.swift
//  SetGame2
//
//  Created by Anna Rieckmann on 16.11.23.
//

import SwiftUI

@main
struct SetGame2App: App {
    var body: some Scene {
        let game = ViewModel()
        WindowGroup {
            ContentView(game: game)
        }
    }
}
