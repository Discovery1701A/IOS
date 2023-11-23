//
//  GausenApp.swift
//  Gausen
//
//  Created by Anna Rieckmann on 23.11.23.
//

import SwiftUI

@main
struct GausenApp: App {
    let modelView = ViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(modelView: modelView)
        }
    }
}
