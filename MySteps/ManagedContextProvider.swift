//
//  ManagedContextProvider.swift
//  MySteps
//
//  Created by Bogusław Parol on 02/03/2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import Foundation
import CoreData

class ManagedContextProvider {
    
    static let shared = ManagedContextProvider()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        
        if let context = self.backgroundContext, context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private(set) var backgroundContext: NSManagedObjectContext?
    
    // MARK: - PRIVATE
    
    private init() {
        self.createPersistentContainer()
    }
    
    private func createPersistentContainer() {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MySteps")
        container.loadPersistentStores(completionHandler: { [weak self] (storeDescription, error) in
            if let error = error as NSError? {
                // TODO: handle error
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                self?.backgroundContext = container.newBackgroundContext()
            }
        })
    }
}
