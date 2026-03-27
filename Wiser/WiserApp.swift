//
//  WiserApp.swift
//  Wiser
//
//  Created by Marlin on 26/03/2026.
//

import SwiftUI
import SwiftData

@main
struct WiserApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: FocusSession.self)
    }
}
