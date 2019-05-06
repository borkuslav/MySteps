//
//  TestDataFactory.swift
//  MySteps
//
//  Created by Bogusław Parol on 04/03/2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import Foundation

func getTestStepsReports() -> [DailyStepsReport] {
    
    var list = [DailyStepsReport]()
    let cal = Calendar.current
    for index in 1...15 {
        let components = DateComponents(calendar: cal, year: 2019, month: 3, day: index)
        let report = DailyStepsReport(date: components.date!, steps: Int.random(in: 0...18456))
        list.append(report)
    }
    return list
}


