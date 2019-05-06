//
//  Round.swift
//  MySteps
//
//  Created by Bogusław Parol on 04/03/2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import Foundation

func getRoundedToNearest(majorIntervalLength: Float) -> Int {
    let majorIntervalLengthAsString = "\(Int(majorIntervalLength))"
    guard majorIntervalLengthAsString.count > 0 else {
        return Int(majorIntervalLength)
    }
    let powRes = powf(10.0, Float(majorIntervalLengthAsString.count - 1))
    let roundedMajorIntervalLength = round(majorIntervalLength/powRes) * powRes
    return Int(roundedMajorIntervalLength)
}
