//
//  AppModel.swift
//  TrailMark
//
//  Created by Jonathan Heinzman on 8/3/26.
//

import Foundation
import Observation
import TrailMarkCore

@MainActor
@Observable
final class AppModel {
    let health = HealthKitManager()
    let media = MediaStore()
    let location = LocationManager()
}

