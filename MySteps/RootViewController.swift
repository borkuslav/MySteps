//
//  RootViewController.swift
//  MySteps
//
//  Created by Boguslaw Parol on 02.03.2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import Foundation
import UIKit

protocol RootViewType: class {
    
    func showMyStepsView(_ viewModel: MyStepsViewModelType)
}

class RootViewController: UIViewController {
    
    private var viewModel: RootViewModelType = RootViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.view = self
        self.viewModel.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension RootViewController: RootViewType {
    
    func showMyStepsView(_ viewModel: MyStepsViewModelType) {
        let myStepsViewController = MyStepsViewController(nibName: "MySteps", viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: myStepsViewController)
        self.view.addSubview(navigationController.view)
        self.addChild(navigationController)
        navigationController.didMove(toParent: self)
    }
}
