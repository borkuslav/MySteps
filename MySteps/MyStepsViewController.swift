//
//  ViewController.swift
//  MySteps
//
//  Created by Boguslaw Parol on 02.03.2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import UIKit

protocol MyStepsViewType: class {
    
    func drawChart(dailyReports: [DailyStepsReport])
    
    func hideChartContainer()
    
    func setDatesRange(_ dateString: String)
    
    func setTotalSteps(_ totalSteps: String)
    
    func drawAchievements(achievements: [Achievement])
    
    func drawNoAchievements()
}

class MyStepsViewController: UIViewController {

    private var viewModel: MyStepsViewModelType
    @IBOutlet var myStepsView: MyStepsView!
    
    init(nibName: String, viewModel: MyStepsViewModelType ) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
        self.viewModel.view = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = .blackOpaque
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = .white       
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.text = self.viewModel.title
        titleLabel.textColor = .white
        self.navigationItem.titleView = titleLabel
        
        self.viewModel.viewDidLoad()
        self.myStepsView.draw(self.viewModel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MyStepsViewController: MyStepsViewType {
    
    func drawAchievements(achievements: [Achievement]) {
        self.myStepsView.drawAchievements(achievements: achievements)
    }
    
    func drawNoAchievements() {
        self.myStepsView.drawNoAchievementsYet()
    }
    
    func hideChartContainer() {
        self.myStepsView.chartContainerHeight.constant = 0
    }

    func drawChart(dailyReports: [DailyStepsReport]) {
        let chartView = StepsChartView(
            frame: self.myStepsView.chartContainerView.bounds,
            stepsReports: dailyReports)
        self.myStepsView.chartContainerView.addSubview(chartView)
    }
    
    func setDatesRange(_ dateString: String) {
        self.myStepsView.datesRangeLabel.text = dateString
    }
    
    func setTotalSteps(_ totalSteps: String) {
        self.myStepsView.stepsCountLabel.text = totalSteps
    }
}

