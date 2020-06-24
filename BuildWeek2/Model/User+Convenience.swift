//
//  User+Convienece.swift
//  BuildWeek2
//
//  Created by Clayton Watkins on 6/18/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation
import CoreData

extension User {
    //MARK: - Properties
    var userRepresentation: UserRepresentation? {
    }
    
    // MARK: - Convenience Initalizers
    // User data object Initializer
    @discardableResult convenience init(id: Int16,
                                        username: String,
                                        password: String,
                                        phoneNumber: String,
                                        avatarUrl: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(context: context)
        self.id = id
        self.username = username
        self.password = password
        self.phoneNumber = phoneNumber
        self.avatarUrl = avatarUrl
    }
}
