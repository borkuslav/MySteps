//
//  DataBaseHelper.swift
//  MySteps
//
//  Created by Boguslaw Parol on 02.03.2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import Foundation
import CoreData

class DataBaseHelper {    
    
    func getUser() throws -> User? {
        guard let context = ManagedContextProvider.shared.backgroundContext else {
            throw ErrorType.loadingDatabaseError
        }
        
        if let cdUser = try context.fetch(NSFetchRequest<CDUser>(entityName: "User")).first {
            return User(cdUser: cdUser)
        }
        return nil
    }
    
    func createUser(name: String, imageName: String) throws -> User? {
        guard let context = ManagedContextProvider.shared.backgroundContext else {
            throw ErrorType.loadingDatabaseError
        }
        
        let cdUser = CDUser(context: context)
        cdUser.identifier = String(Date().timeIntervalSince1970)
        cdUser.name = name
        cdUser.imageName = imageName
        try context.save()
        return User(cdUser: cdUser)        
    }
    
    func createCDDailyStepsReport(date: Date, steps: Int) throws {
        guard let context = ManagedContextProvider.shared.backgroundContext else {
            throw ErrorType.loadingDatabaseError
        }
        
        let cdReport = CDDailyStepsReport(context: context)
        cdReport.date = date
        cdReport.stepsCount = Int32(steps)
    }
    
    func cacheReports(reports: [DailyStepsReport]) throws {
        guard let context = ManagedContextProvider.shared.backgroundContext else {
            throw ErrorType.loadingDatabaseError
        }
        
        let fetchReports: NSFetchRequest<CDDailyStepsReport> = CDDailyStepsReport.fetchRequest()
        let cdReports = try context.fetch(fetchReports).filter{ $0.date != nil }

        reports.forEach { report in
            let cdReport = cdReports.first(where: { iteratedCDReport in
                return iteratedCDReport.date! == report.date
            })
            do {
                if let cdReport = cdReport {
                    // update existing db record
                    cdReport.stepsCount = Int32(report.steps)
                } else {
                    // create new db record
                    try self.createCDDailyStepsReport(date: report.date, steps: report.steps)
                }
                try context.save()
            } catch {
                debugPrint(error)
            }
        }
    }
    
    func saveAchievements(achievements: [Achievement]) throws {
        guard let context = ManagedContextProvider.shared.backgroundContext else {
            throw ErrorType.loadingDatabaseError
        }
        
        let cachedAchievements = try getAchievements()
        
        achievements.forEach { achievement in
            guard !cachedAchievements.contains(where: { cachedAchievement in
                return cachedAchievement.identifier == achievement.identifier
            }) else {
                return
            }
            
            let cdAchievement = CDAchievement(context: context)
            cdAchievement.identifier = achievement.identifier            
        }
        
        try context.save()        
    }
    
    func getAchievements() throws -> [Achievement] {
        guard let context = ManagedContextProvider.shared.backgroundContext else {
            throw ErrorType.loadingDatabaseError
        }
        
        let fetchAchievements: NSFetchRequest<CDAchievement> = CDAchievement.fetchRequest()
        let cdAchievements = try context.fetch(fetchAchievements)
        
        return cdAchievements.filter {$0.identifier != nil }.map { cdAchievement in
            return Achievement(identifier: cdAchievement.identifier!)
        }.sorted(by: { (one, two) -> Bool in
            return one.identifier < two.identifier
        })
    }
}
