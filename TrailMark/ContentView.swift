//
//  ContentView.swift
//  TrailMark
//
//  Created by Jonathan Heinzman on 8/3/26.
//

import SwiftUI
import TrailMarkCore

struct ContentView: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        TabView {
            TodayDashboardView()
                .tabItem { Label("Today", systemImage: "sum.max.fill") }
        }
        .task {
            await model.health.requestAuthorization()
            await model.health.refreshToday()
        }
    }
}

#Preview {
    ContentView()
}
