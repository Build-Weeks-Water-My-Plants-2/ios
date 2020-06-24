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
        guard let username = username,
            let password = password,
            let phoneNumber = phoneNumber,
            let avatarUrl = avatarUrl
            else { return nil }
        return UserRepresentation(id: Int(id), username: username, password: password, phoneNumber: phoneNumber, avatarUrl: avatarUrl)
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
    
    @discardableResult convenience init?(userRepresentation: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(id: Int16(userRepresentation.id),
                  username: userRepresentation.username,
                  password: userRepresentation.password,
                  phoneNumber: userRepresentation.phoneNumber ?? "",
                  avatarUrl: userRepresentation.avatarUrl ?? "",
                  context: context)
    }
    
}
