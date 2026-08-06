//
//  RouteTrack.swift
//  TrailMarkCore
//
//  Created by Jonathan Heinzman on 8/5/26.
//

import Foundation
import CoreLocation

// MARK: - Mock Building Blocks

extension TrackPoint{
    static func mockID( _ index: Int) -> UUID {
        UUID(uuidString: String(format:"00000000-0000-0000-%012d", index)) ?? UUID()
    }
}

extension RouteTrack {
    public static let mockStartDate = Date(timeIntervalSince1970: 1_785_983_510)
    
    public struct MockWayPoint: Sendable {
        public var latitude: Double
        public var longitude: Double
        public var altitude: Double
        
        public init(_ latitude: Double,_ longitude: Double,_ altitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
            self.altitude = altitude
        }
    }
    
    public static func mock(
        waypoints: [MockWayPoint],
        samplesPerSegment: Int = 10,
        start: Date = RouteTrack.mockStartDate,
        sampeInterval: TimeInterval = 5
    ) -> RouteTrack {
        guard let first = waypoints.first else {
            return RouteTrack()
        }
        guard waypoints.count > 1 else {
            return RouteTrack(points: [
                TrackPoint(
                    id: TrackPoint.mockID(0),
                    latitude: first.latitude,
                    longitude: first.longitude,
                    altitude: first.altitude,
                    timestamp: start
                )
            ])
        }
        
        var points: [TrackPoint] = []
        
        // This will give us an array with N-1 elements
        for (segmentIndex, origin) in waypoints.dropLast().enumerated() {
            let destination = waypoints[segmentIndex + 1]
            let isFinalSegment = segmentIndex == waypoints.count - 1
            let stepCount = isFinalSegment ? samplesPerSegment : samplesPerSegment - 1
            
            for step in 0...stepCount {
                let progress = Double(step) / Double(samplesPerSegment)
                
                let index = points.count
                
                points.append(
                    TrackPoint(
                        id: TrackPoint.mockID(index),
                        latitude: origin.latitude + (destination.latitude - origin.latitude) * progress,
                        longitude: origin.longitude + (destination.longitude - origin.longitude) * progress,
                        altitude: origin.altitude + (destination.altitude - origin.altitude) * progress
                    )
                )
            }
        }
        
        return RouteTrack(points: points)
    }
}

