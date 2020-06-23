//
//  PlantRepresentation.swift
//  BuildWeek2
//
//  Created by Clayton Watkins on 6/18/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation

struct PlantRepresentation: Equatable, Codable{
    var id: Int
    var nickname: String
    var species: String?
    var h20Frequencey: Int?
    var userId: Int?
    var avatarUrl: String?
    var happiness: Bool?
    var lastWateredAt: Date?
}
