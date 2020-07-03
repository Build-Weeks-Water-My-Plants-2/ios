import Foundation
import CoreData
import CoreDataStack

extension Plant {
   // MARK: - Properties
   
   // If you already have a Plant, this will turn it into it's representation
   var plantRepresentation: PlantRepresentation? {
      let formatter = DateFormatter()
      formatter.timeStyle = .short
      formatter.dateStyle = .short
      guard let nickname = nickname else { return nil }
      
      return PlantRepresentation(id: id?.intValue,
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
   @discardableResult convenience init(id: Int?,
                                       nickname: String,
                                       species: String,
                                       h20Frequencey: Int16,
                                       avatarUrl: String,
                                       happiness: Bool,
                                       context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
      self.init(context: context)
      if let id = id {
         self.id = NSNumber(value: id)
      }
      self.nickname = nickname
      self.species = species
      self.h20Frequency = h20Frequencey
      self.avatarUrl = avatarUrl
      self.happiness = happiness
   }
   
   // This will convert a PlantRepresentation into a Plant object for saving on Coredata
   @discardableResult convenience init?(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
      self.init(id: plantRepresentation.id,
                nickname: plantRepresentation.nickname,
                species: plantRepresentation.species ?? "",
                h20Frequencey: Int16(plantRepresentation.h20Frequencey ?? 0),
                avatarUrl: plantRepresentation.avatarUrl ?? "",
                happiness: plantRepresentation.happiness ?? false,
                context: context)
   }
}
