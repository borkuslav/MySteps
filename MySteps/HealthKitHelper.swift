//
//  HealthKitHelper.swift
//  MySteps
//
//  Created by Boguslaw Parol on 02.03.2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitHelper {
    
    static var isAvailable: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    func requestAuthorization(completion: @escaping () -> Void, failure: @escaping (Error?) -> Void) {
        let allTypes = Set([HKObjectType.workoutType(),
                            HKObjectType.quantityType(forIdentifier: .stepCount)!])
        
        HealthStoreProvider.shared.healthStore?.requestAuthorization(toShare: nil, read: allTypes) { (success, error) in
            if !success {
                failure(error)
            } else {
                completion()
            }
        }
    }
    
    func getSteps(completion: @escaping ([DailyStepsReport]) -> Void) {
        
        let calendar = Calendar.current
        
        //   Get today date at 00:00
        let todayDateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        guard let todayDate = calendar.date(from: todayDateComponents) else {
            return // TODO: handle error
        }
    
        // Get anchor date
        guard let anchorDate = calendar.date(byAdding: .day, value: -30, to: todayDate) else {
            return // TODO: handle error
        }
        
        // Get end date
        let endDate = Date()
        
        //  Set the Predicates & Interval
        let predicate = HKQuery.predicateForSamples(withStart: anchorDate, end: endDate, options: .strictStartDate)
        var interval = DateComponents()
        interval.day = 1
        
        //   Define the Step Quantity Type
        guard let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            return // TODO: handle error
        }
        
        //  Perform the Query
        let query = HKStatisticsCollectionQuery(
            quantityType: stepsCount,
            quantitySamplePredicate: predicate,
            options: [.cumulativeSum],
            anchorDate: anchorDate,
            intervalComponents:interval)
        
        query.initialResultsHandler = { query, results, error in
            
            var dailyReports = [DailyStepsReport]()
            results?.enumerateStatistics(from: anchorDate, to: endDate, with: { (stats, stop) in
                if let stepsCount = stats.sumQuantity() {                    
                    let dailyReport = DailyStepsReport(
                        date: stats.startDate,
                        steps: Int(floor(stepsCount.doubleValue(for: HKUnit.count())))
                    )
                    dailyReports.append(dailyReport)
                }
            })
            completion(dailyReports)
        }
        
        HealthStoreProvider.shared.healthStore?.execute(query)
    }
}
