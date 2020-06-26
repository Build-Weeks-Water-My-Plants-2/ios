import Foundation
import CoreData

extension Plant {
    
    // MARK: - Properties
    
    // If you already have a Plant, this will turn it into it's representation
    var plantRepresentation: PlantRepresentation? {
        guard let nickname = nickname else { return nil }
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
    @discardableResult convenience init(
        nickname: String,
        species: String,
        h20Frequencey: Int16,
        avatarUrl: String,
        happiness: Bool,
        lastWateredAt: Date = Date(),
        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.nickname = nickname
        self.species = species
        self.h20Frequency = h20Frequencey
        self.avatarUrl = avatarUrl
        self.happiness = happiness
        self.lastWateredAt = lastWateredAt
    }
    
    // This will convert a PlantRepresentation into a Plant object for saving on Coredata
    @discardableResult convenience init?(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(
            nickname: plantRepresentation.nickname,
            species: plantRepresentation.species ?? "",
            h20Frequencey: Int16(plantRepresentation.h20Frequencey ?? 0),
            avatarUrl: plantRepresentation.avatarUrl ?? "",
            happiness: plantRepresentation.happiness ?? false,
            lastWateredAt: plantRepresentation.lastWateredAt ?? Date(),
            context: context)
    }
}
