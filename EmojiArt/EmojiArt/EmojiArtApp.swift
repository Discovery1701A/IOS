//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Anna Rieckmann on 13.11.23.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let document = EmojiArtDocument ()
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
