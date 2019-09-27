//
//  CoreDataStack.swift
//  ShoppingList
//
//  Created by Jordan Lamb on 9/27/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ShoppingList")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to Load Persistent Store \(error)")
            }
        })
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
}

