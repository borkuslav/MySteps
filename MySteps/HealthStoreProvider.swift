//
//  HealthKitStoreProvider.swift
//  MySteps
//
//  Created by Bogusław Parol on 03/03/2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import Foundation
import HealthKit

class HealthStoreProvider {
    
    static let shared = HealthStoreProvider()
    
    private init() {
        if HealthKitHelper.isAvailable {
            self.healthStore = HKHealthStore()
        }
    }
    
    private(set) var healthStore: HKHealthStore?
}
