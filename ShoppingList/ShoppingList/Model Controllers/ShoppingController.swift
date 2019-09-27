//
//  ShoppingController.swift
//  ShoppingList
//
//  Created by Jordan Lamb on 9/27/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import Foundation
import CoreData

class ShoppingController {
    
    // Shared
    static let shared = ShoppingController()
    
    // SOT
    let fetchResultsController: NSFetchedResultsController<Shopping>
    init() {
        let fetchRequest: NSFetchRequest<Shopping> = Shopping.fetchRequest()
        let purchasedSort = NSSortDescriptor(key: "isPurchased", ascending: true)
        let timeSort = NSSortDescriptor(key: "dateAdded", ascending: false)
        fetchRequest.sortDescriptors = [purchasedSort, timeSort]
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isPurchased", cacheName: nil)
        fetchResultsController = resultsController
        do {
            try fetchResultsController.performFetch()
        } catch {
            print("There was an error fetching from fetch Controller: \(error)")
        }
    }
    
    // CRUD
    // Create
    func createItem(itemWithName name: String) {
        _ = Shopping(itemName: name)
        saveToPersistenceStore()
    }
    
    // Delete
    func deleteItem(shopping: Shopping) {
        shopping.managedObjectContext?.delete(shopping)
        saveToPersistenceStore()
    }
    
    func toggleIsPurchased(shopping: Shopping) {
        shopping.isPurchased = !shopping.isPurchased
        saveToPersistenceStore()
        print("toggleIsPurchased is \(shopping.isPurchased)")
    }
    
    // Save
    func saveToPersistenceStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving Managed Object Context. Items not saved.")
        }
    }
} // End of Class
