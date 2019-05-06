//
//  MyStepsViewModel.swift
//  MySteps
//
//  Created by Boguslaw Parol on 02.03.2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import Foundation

protocol MyStepsViewModelType {
    
    var view: MyStepsViewType? { get set }
    
    var title: String? { get }
    var userImageName: String? { get }
    
    var stepsTitle: String? { get }
    var stepsCount: String? { get }
    var datesRange: String? { get }
    
    var achievementsTitle: String? { get }
    
    func viewDidLoad()
}

class MyStepsViewModel: MyStepsViewModelType {
    
    weak var view: MyStepsViewType?
    
    var title: String? {
        return user.name
    }
    
    var userImageName: String? {
        return user.imageName
    }
    
    var stepsTitle: String? {
        return NSLocalizedString("Steps", comment: "Chart title")
    }
    
    var stepsCount: String? {
        return ""
    }
    
    var datesRange: String? {
        return ""
    }
    
    var achievementsTitle: String? {
        return NSLocalizedString("Achievements", comment: "Achievements title")
    }
    
    func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(dayChanged), name: .NSCalendarDayChanged, object: nil)
        
        self.healthKitHelper.requestAuthorization(completion: { [weak self] in
            DispatchQueue.main.async {
                self?.didAuthorizeInHealthStore()
            }
        }) { error in            
            // TODO: show error message
        }
    }
    
    init(user: User) {
        self.user = user
    }
    
    // MARK: - PRIVATE
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private var user: User
    private var healthKitHelper = HealthKitHelper()
    private var databaseHelper = DataBaseHelper()
    
    private func didAuthorizeInHealthStore() {
        self.loadSteps()
    }
    
    private func loadSteps() {
        self.healthKitHelper.getSteps { [weak self] reports in
            DispatchQueue.main.async {
                guard let this = self else {
                    return
                }
                
                // TODO: uncomment to test
                //let reports = getTestStepsReports()
                
                // set dates range string
                if let firstReport = reports.first, let lastReport = reports.last {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    let dateFrom = dateFormatter.string(from: firstReport.date)
                    let dateTo = dateFormatter.string(from: lastReport.date)
                    let dateString = "\(dateFrom) - \(dateTo)"
                    this.view?.setDatesRange(dateString)
                }
                // set total steps
                let totalSteps = reports.reduce(0, { (res, report) in
                    return res + report.steps
                })
                this.view?.setTotalSteps("\(Int(totalSteps))")
                // draw chart
                if !reports.isEmpty {
                    this.view?.drawChart(dailyReports: reports)
                } else {
                    this.view?.hideChartContainer()
                }
                // cache, retrieve and draw achievements
                let stepsPerAchievement = 5000
                let achievementsCount = totalSteps / stepsPerAchievement
                let maxAchievements = 7
                if achievementsCount > 0 {
                    var achievements = [Achievement]()
                    for index in 1...min(achievementsCount, maxAchievements) {
                        let achievementThreshold = 5000 + index * stepsPerAchievement
                        let achievement = Achievement(identifier: "\(achievementThreshold/1000)k")
                        achievements.append(achievement)
                    }
                    try? this.databaseHelper.saveAchievements(achievements: achievements)
                    if let achievementsFromCache = try? this.databaseHelper.getAchievements() {
                        this.view?.drawAchievements(achievements: achievementsFromCache)
                    }
                } else {
                    this.view?.drawNoAchievements()
                }
                // cache steps
                try? self?.databaseHelper.cacheReports(reports: reports)
            }
        }
    }
    
    @objc private func dayChanged() {
        self.loadSteps()
        // TODO: after date was changed to next day, HealthKit doesn't return report for a new current day.
        // even Health app doesn't show report...
    }
}
