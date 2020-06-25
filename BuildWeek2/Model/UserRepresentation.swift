//
//  UserRepresentation.swift
//  BuildWeek2
//
//  Created by Clayton Watkins on 6/23/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    var id: Int
    var username: String
    var password: String
    var phoneNumber: String?
    var avatarUrl: String?
}
