//
//  TrailMarkApp.swift
//  TrailMark
//
//  Created by Jonathan Heinzman on 8/3/26.
//

import SwiftUI

@main
struct TrailMarkApp: App {
    @State private var model = AppModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }
    }
}
