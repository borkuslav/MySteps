//
//  StepsChartViewDataSurce.swift
//  MySteps
//
//  Created by Bogusław Parol on 04/03/2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import Foundation
import CorePlot

class StepsChartViewDataSource: NSObject, CPTPlotDataSource {
    
    private var plotData: [Dictionary<String, Any>]
    
    init(stepsReports: [DailyStepsReport]) {
        var index = 0
        self.plotData = stepsReports.map { dailyReport in
            defer {
                index = index + 1
            }
            debugPrint("\(dailyReport.day) - \(index) -  \(dailyReport.steps)")
            return [
                "x": index,
                "y": dailyReport.steps
            ]
        }
    }
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(self.plotData.count)
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        let key = fieldEnum == UInt(CPTScatterPlotField.X.rawValue) ? "x" : "y"
        let record = self.plotData[Int(idx)]
        return record[key]
    }
}
