//
//  CoreDataStack.swift
//  BuildWeek2
//
//  Created by Clayton Watkins on 6/18/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation
import CoreData

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserData")
        container.loadPersistentStores { (_, error) in
            if let error = error{
                fatalError("Failed to load persistence stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        context.performAndWait {
            do{
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        if let error = error { throw error }
    }
}