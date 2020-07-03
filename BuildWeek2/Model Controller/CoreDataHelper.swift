import Foundation
import CoreData
import CoreDataStack

class CoreDataHelper {
   static func updatePlants(with representations: [PlantRepresentation]) {
      CoreDataStack.shared.container.performBackgroundTask { context in
         // Removing all temporary Plants without id
         
         let temporaryFetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
         temporaryFetchRequest.predicate = NSPredicate(format: "id == nil")

         let temporaryPlants: [Plant]
         
         do {
            temporaryPlants = try context.fetch(temporaryFetchRequest)
         } catch {
            print("Error fetching plants with empty ids")
            return
         }
         
         temporaryPlants.forEach { plant in
            context.delete(plant)
         }
         
         // Updating existing Plants and adding new Plants
                  
         let ids = representations.compactMap { representation -> Int? in
            representation.id
         }
         
         let representationByID = Dictionary(uniqueKeysWithValues: zip(ids, representations))
                           
         let existingFetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
         existingFetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
         
         let existingPlants: [Plant]
         
         do {
            existingPlants = try context.fetch(existingFetchRequest)
         } catch {
            print("Error fetching plants")
            return
         }
         
         // Updating existing Plants
         existingPlants.forEach { plant in
            guard let id = plant.id?.intValue, let representation = representationByID[id] else { return }
            update(plant: plant, with: representation)
         }
         
         // Adding new Plants
         let newPlantRepresentations = representations.filter { candidate -> Bool in
            let contains = existingPlants.contains { plant -> Bool in
                plant.id?.intValue == candidate.id
            }
            return !contains
         }
         
         newPlantRepresentations.forEach { representation in
            Plant(plantRepresentation: representation, context: context)
         }
         
         // Saving
         do {
            try context.save()
         } catch {
            print("Error saving context")
            return
         }
      }
   }
   
   private static func update(plant: Plant, with representation: PlantRepresentation) {
      plant.avatarUrl = representation.avatarUrl
      plant.lastWateredAt = representation.lastWateredAt
      plant.nickname = representation.nickname
      plant.species = representation.species

      if let h20Frequencey = representation.h20Frequencey {
         plant.h20Frequency = Int16(h20Frequencey)
      }

      if let happiness = representation.happiness {
         plant.happiness = happiness
      }

      if let userId = representation.userId {
         plant.userId = Int16(userId)
      }
   }
}
