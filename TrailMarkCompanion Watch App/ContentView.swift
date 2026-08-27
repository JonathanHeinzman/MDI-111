//
//  ContentView.swift
//  TrailMarkCompanion Watch App
//
//  Created by Jonathan Heinzman on 8/3/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(WatchModel.self) private var model
    var body: some View {
        NavigationStack {
            List {
                WristHomeView()
                
                Section{
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
