//
//  PlantRepresentation.swift
//  BuildWeek2
//
//  Created by Clayton Watkins on 6/18/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation

struct PlantRepresentation: Equatable, Codable{
    var id: Int16?
    var nickname: String
    var species: String
    var h20Frequencey: Int16?
    var userId: Int16?
    var avatarUrl: String
    var happiness: Bool?
    var lastWateredAt: Date
}
