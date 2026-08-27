//
//  Untitled.swift
//  TrailMark
//
//  Created by Jonathan Heinzman on 8/24/26.
//

import SwiftUI
import TrailMarkCore

struct WristHomeView: View {
    @Environment(WatchModel.self) private var model
    
    
    var body: some View {
        Section{
            VStack(alignment: .leading, spacing: 2){
                Text("Steps Today")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(model.health.todaySummary.stepsText)
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(.orange)
                    .contentTransition(.numericText())
                Text(model.health.todaySummary.distanceText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    
                    
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .listRowBackground(Color.clear)
        }
    }
}
