//
//  RootViewModel.swift
//  MySteps
//
//  Created by Boguslaw Parol on 02.03.2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import Foundation

protocol RootViewModelType: class {
    
    var view: RootViewType? { get set}
    
    func viewDidLoad()
}

class RootViewModel: RootViewModelType {
    
    weak var view: RootViewType?
    
    private var databaseHelper = DataBaseHelper()
    
    func viewDidLoad() {
        do {
            var user = try self.databaseHelper.getUser()
            if user == nil {
                user = try self.databaseHelper.createUser(name: "Neil Armstrong", imageName: "profile-photo")
            }
            
            if let user = user {
                self.view?.showMyStepsView(MyStepsViewModel(user: user))
            }
        } catch {
            debugPrint(error)
        }
    }
    
}
