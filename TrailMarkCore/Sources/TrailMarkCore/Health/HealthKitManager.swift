//
//  HealthKitManager.swift
//
//  TrailMarkCore
//
//  Created by Jonathan Heinzman on 8/12/26.
//

import Foundation
import HealthKit
import Observation

@MainActor
@Observable
public final class HealthKitManager {
    
    public enum AuthorizationStatus: Equatable {
        case unknown
        case unavailable
        case requesting
        case authorized
        case denied
    }
    
    public private(set) var authorizationStatus: AuthorizationStatus = .unknown
    
    public private(set) var todaySummary: ActivitySummary = .empty // steps, distanceMeters, activeEnergyKcal (hkSampleQuery)
    public private(set) var sleep: SleepSummary = .empty // asleepSeconds (hkSampleQuery)
    public private(set) var energyTrend: [EnergyTrendPoint] = [] // activeEnergyKcal (hkStatistics)
    public private(set) var liveVital: LiveVitals = .empty // heartRate, steps, activeEnergyKcal (real time continuous)
    
    private let store = HKHealthStore()
    private var liveQuery: [HKQuery] = []
    
    public init() {
        if HKHealthStore.isHealthDataAvailable() {
            authorizationStatus = .unavailable
        }
    }
    
    // MARK: - All Health Data Types That The App Interacts With
    private var stepType: HKQuantityType { HKQuantityType(.stepCount) }
    private var distanceType: HKQuantityType { HKQuantityType(.distanceWalkingRunning) }
    private var energyType: HKQuantityType { HKQuantityType(.activeEnergyBurned) }
    private var sleepType: HKCategoryType { HKCategoryType(.sleepAnalysis) }
    private var heartRateType: HKQuantityType { HKQuantityType(.heartRate) }
    
    private var readTypes: Set<HKObjectType> {
        [stepType, distanceType, energyType, heartRateType, HKObjectType.workoutType()]
    }
    
    private var shareTypes: Set<HKSampleType> {
        [energyType, distanceType, HKObjectType.workoutType()]
    }
    
    public func requestAuthorization() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            authorizationStatus = .unavailable
            return
        }
        authorizationStatus = .requesting
        
        do {
            try await store.requestAuthorization(toShare: shareTypes, read: readTypes)
            // Note: for privacy ios necer tells us whether read access was granted
            // We treat requests completed as authorized and let zeroes summary stand for the denied empty case
            authorizationStatus = .authorized
        }catch {
            authorizationStatus = .denied
        }
    }
    
    // MARK: - Sleep Data Query
    public func refreshLastNightSleep() async {
        guard authorizationStatus == .authorized else { return }
        
        // Create the time windows for last night (time windows (StartDate to EndDate) -> time predicate)
        let calendar = Calendar.current
        let now = Date()
        
        // windows: 6pm yesterday -> noon today, which brackets a normal night
        let noonToday = calendar.date(bySettingHour: 12, minute: 0, second: 0,of: now) ?? now
        let sixPmYesterday = calendar.date(byAdding: .hour, value: -18, to: noonToday) ?? now
        
        let samples: [HKCategorySample] = await withCheckedContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: sixPmYesterday, end: noonToday)
            let query = HKSampleQuery(
                sampleType: sleepType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil
            ) { query, results, error in
                continuation.resume(returning: (results as? [HKCategorySample]) ?? [])
            }
            
            store.execute(query)
        }
        
        // Processing Data Part
    }
}




