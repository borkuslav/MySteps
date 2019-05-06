//
//  MyStepsView.swift
//  MySteps
//
//  Created by Bogusław Parol on 03/03/2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import Foundation
import UIKit

class MyStepsView: UIView {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var stepsTitleLabel: UILabel!
    @IBOutlet weak var stepsCountLabel: UILabel!
    @IBOutlet weak var datesRangeLabel: UILabel!
    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var chartContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var achievementsTitleLabel: UILabel!
    @IBOutlet weak var achievementsCountLabel: UILabel!
    @IBOutlet weak var achievementsContainer: UIView!
    private var scrollView: UIScrollView?
    private var stackView: UIStackView?
    
    override func awakeFromNib() {
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2
    }
    
    func draw(_ viewModel: MyStepsViewModelType) {
        if let imageName = viewModel.userImageName {
            self.userImageView.image = UIImage(named: imageName)
        }
        self.stepsTitleLabel.text = viewModel.stepsTitle
        self.stepsCountLabel.text = viewModel.stepsCount
        self.datesRangeLabel.text = viewModel.datesRange    
    }
    
    func drawAchievements(achievements: [Achievement]) {
        self.achievementsCountLabel.text = "\(achievements.count)"
        
        // add scrollview
        let scrollView = UIScrollView(frame: self.achievementsContainer.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.achievementsContainer.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: self.achievementsContainer.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: self.achievementsContainer.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.achievementsContainer.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.achievementsContainer.bottomAnchor)
        ])
        self.scrollView = scrollView
        // create horizontal stackview
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 32
        for achievement in achievements {
            if let achievementView = UINib(nibName: "Achievement", bundle: nil).instantiate(withOwner: nil, options: nil).first as? AchievementView {
                achievementView.draw(achievement: achievement)
                stackView.addArrangedSubview(achievementView)
            }
        }
        self.stackView = stackView
        // size stackview
        let size = stackView.systemLayoutSizeFitting(CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        // set scrollView container height
        NSLayoutConstraint.activate([
            self.achievementsContainer.heightAnchor.constraint(equalToConstant: size.height)
        ])
        // add stack view to scrollView
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        self.achievementsContainer.setNeedsLayout()
        self.achievementsContainer.layoutIfNeeded()
        scrollView.contentSize = size
    }
    
    func drawNoAchievementsYet() {
        self.achievementsCountLabel.text = nil
        if let noAchievementsYet = UINib(nibName: "NoAchievements", bundle: nil).instantiate(withOwner: nil, options: nil).first as? NoAchievementsView {
            // set  container height
            let size = noAchievementsYet.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
            NSLayoutConstraint.activate([
                self.achievementsContainer.heightAnchor.constraint(equalToConstant: size.height)
            ])
            
            self.achievementsContainer.addSubview(noAchievementsYet)
            NSLayoutConstraint.activate([
                noAchievementsYet.leftAnchor.constraint(equalTo: self.achievementsContainer.leftAnchor),
                noAchievementsYet.topAnchor.constraint(equalTo: self.achievementsContainer.topAnchor),
                {
                    let right = noAchievementsYet.rightAnchor.constraint(equalTo: self.achievementsContainer.rightAnchor)
                    right.priority = .defaultHigh
                    return right
                }(),
                {
                    let bottom = noAchievementsYet.bottomAnchor.constraint(equalTo: self.achievementsContainer.bottomAnchor)
                    bottom.priority = .defaultHigh
                    return bottom
                }()
            ])
        }
    }
}
