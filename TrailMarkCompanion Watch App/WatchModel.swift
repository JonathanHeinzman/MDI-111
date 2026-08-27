//
//  WatchModel.swift
//  TrailMark
//
//  Created by Jonathan Heinzman on 8/24/26.
//

import Foundation
import Observation
import TrailMarkCore

@MainActor
@Observable
final class WatchModel {
    let health = HealthKitManager()
    let media = MediaStore()
    let motion = MotionManager()
    let workout = WorkoutSessionManager()
}
