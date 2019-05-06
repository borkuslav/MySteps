//
//  AxisFormatters.swift
//  MySteps
//
//  Created by Bogusław Parol on 04/03/2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import Foundation

class AxisYLabelFormatter: Formatter {
    
    override func string(for obj: Any?) -> String? {
        if let obj = obj {
            return "\(obj)"
        }
        return ""
    }
}

class AxisXLabelFormatter: Formatter {
    
    private var stepsReports: [DailyStepsReport]
    
    init(stepsReports: [DailyStepsReport]){
        self.stepsReports = stepsReports
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func string(for obj: Any?) -> String? {
        guard let reportIndex = obj as? Int else {
            return ""
        }
        
        if reportIndex >= 0 && reportIndex < self.stepsReports.count {
            let day = self.stepsReports[reportIndex].day
            return "\(day)"
        }
        return ""
    }
}
