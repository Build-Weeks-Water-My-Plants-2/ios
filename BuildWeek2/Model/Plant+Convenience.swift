//
//  Plant+Convience.swift
//  BuildWeek2
//
//  Created by Clayton Watkins on 6/18/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation
import CoreData

extension Plant{
    
    // MARK: -  Properties
    // If you already have a Plant, this will turn it into it's representation
    var plantRepresentation: PlantRepresentation?{
        guard let nickname = nickname else { return nil}
        return PlantRepresentation(id: Int(id),
                                   nickname: nickname,
                                   species: species ?? "",
                                   h20Frequencey: Int(h20Frequency),
                                   userId: Int(userId),
                                   avatarUrl: avatarUrl,
                                   happiness: happiness,
                                   lastWateredAt: lastWateredAt)
    }
    
    // MARK: - Convenience Initalizers
    // Plant data object Initalizer
    @discardableResult convenience init(id: Int16,
                                        nickname: String,
                                        species: String,
                                        h20Frequencey: Int16,
                                        userId: Int16,
                                        avatarUrl: String,
                                        happiness: Bool,
                                        lastWateredAt: Date,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(context: context)
        self.id = id
        self.nickname = nickname
        self.species = species
        self.h20Frequency = h20Frequencey
        self.userId = userId
        self.avatarUrl = avatarUrl
        self.happiness = happiness
        self.lastWateredAt = lastWateredAt
    }
    
    // This will convert a PlantRepresentation into a Plant object for saving on Coredata
    @discardableResult convenience init?(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(id: Int16(plantRepresentation.id),
                  nickname: plantRepresentation.nickname,
                  species: plantRepresentation.species ?? "",
                  h20Frequencey: Int16(plantRepresentation.h20Frequencey ?? 0),
                  userId: Int16(plantRepresentation.userId ?? 0),
                  avatarUrl: plantRepresentation.avatarUrl ?? "",
                  happiness: plantRepresentation.happiness ?? false,
                  lastWateredAt: plantRepresentation.lastWateredAt ?? Date(),
                  context: context)
    }
}
