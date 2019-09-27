//
//  Shopping+Convenience.swift
//  ShoppingList
//
//  Created by Jordan Lamb on 9/27/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import Foundation
import CoreData

extension Shopping {
    convenience init(itemName: String, isPurchased: Bool = false, dateAdded: Date = Date(), context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.itemName = itemName
        self.isPurchased = isPurchased
    }
}
