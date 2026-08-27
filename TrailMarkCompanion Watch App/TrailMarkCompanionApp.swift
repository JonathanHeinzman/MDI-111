//
//  TrailMarkCompanionApp.swift
//  TrailMarkCompanion Watch App
//
//  Created by Jonathan Heinzman on 8/3/26.
//

import SwiftUI

@main
struct TrailMarkCompanion_Watch_AppApp: App {
    @State private var model = WatchModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }
    }
}
