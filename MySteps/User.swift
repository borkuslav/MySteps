//
//  User.swift
//  MySteps
//
//  Created by Boguslaw Parol on 02.03.2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import Foundation
import CoreData

struct User {
    
    var name: String? {
        return self.cdUser.name
    }
    
    var imageName: String? {
        return self.cdUser.imageName
    }
    
    init(cdUser: CDUser) {
        self.cdUser = cdUser
    }
    
    private var cdUser: CDUser
}
