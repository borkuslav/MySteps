//
//  DailyStepsReport.swift
//  MySteps
//
//  Created by Bogusław Parol on 03/03/2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import Foundation

struct DailyStepsReport {
    
    var date: Date
    var steps: Int
    
    var day: Int {
        return Calendar.current.component(.day, from: date)
    }
}
