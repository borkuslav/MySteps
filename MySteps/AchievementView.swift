//
//  AchievementView.swift
//  MySteps
//
//  Created by Bogusław Parol on 05/03/2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import Foundation
import UIKit

class AchievementView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
        self.imageView.clipsToBounds = true
        
    }
    
    func draw(achievement: Achievement) {
        self.subtitleLabel.text = achievement.identifier.uppercased()
        self.imageView.image = UIImage(named: achievement.imageName)
    }
}
