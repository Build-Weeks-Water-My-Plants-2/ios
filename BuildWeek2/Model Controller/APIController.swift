import Foundation
import CoreData

enum NetworkError: Error{
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

class APIController {
    
    
    // MARK: - Properties
    
    private let baseURL = URL(string: "URL GOES HERE")!
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    
    // MARK: - Initializer
    init(){
        self.fetchPlantsFromDatabase()
    }
    
    
    //MARK: - Networking Functions
    
    // Adding plants to our database / Possibly also called when updating the plant in the database
    func addPlantToDatabase(plant: Plant, completion: @escaping CompletionHandler = { _ in }){
        let requestURL = baseURL.appendingPathComponent(String(plant.id)).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do{
            guard let representation = plant.plantRepresentation else{
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding Plant \(plant): \(error)")
            completion(.failure(.noEncode))
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error{
                completion(.failure(.otherError))
                print("Error putting plant to server: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }
    
    // Fetching plants from database
    func fetchPlantsFromDatabase(completion: @escaping CompletionHandler = { _ in }){
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error{
                print("Error fetching plant(s): \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                print("No data returned by data task")
                completion(.failure(.noData))
                return
            }
            
            do{
                let plantRepresentation = Array(try JSONDecoder().decode([Int : PlantRepresentation].self, from: data).values)
                try self.updatePlants(with: plantRepresentation)
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                print("Error decoding plant representation: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
    // Removing plants from database
    func deletePlantsFromDatabase(_ plant: Plant, completion: @escaping CompletionHandler = { _ in }){
        let requestURL = baseURL.appendingPathComponent(String(plant.id)).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }
    
    //MARK: - Private Functions
    
    // Creating a representation of our Plant Object
    private func update(plant: Plant, with representation: PlantRepresentation){
        //        plant.id = Int16(representation.id)
        //        plant.userId = Int16(representation.userId ?? 0)
        plant.nickname = representation.nickname
        plant.species = representation.species
        plant.h20Frequency = Int16(representation.h20Frequencey ?? 0)
        plant.avatarUrl = representation.avatarUrl
        plant.happiness = representation.happiness ?? false
        plant.lastWateredAt = representation.lastWateredAt
    }
    
    // Creating a function that will update our Plant Representation
    private func updatePlants(with representations: [PlantRepresentation]) throws {
        // Creating a new CoreData context so that we aren't saving to the main context while calling this inside of a URLSession.
        let context = CoreDataStack.shared.container.newBackgroundContext()
        // Creating an array of UUIDs
        let idsToFetch = representations.compactMap{Int16($0.id)}
        let representationByID = Dictionary(uniqueKeysWithValues: zip(idsToFetch, representations))
        //Mutable copy of our dictonary to use for new Objects on the remote that we don't have locally
        var plantsToCreate = representationByID
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", idsToFetch)
        context.performAndWait {
            do{
                let existingPlants = try context.fetch(fetchRequest)
                for plant in existingPlants{
                    let id = plant.id
                    guard let representation = representationByID[id] else { continue }
                    self.update(plant: plant, with: representation)
                    plantsToCreate.removeValue(forKey: id)
                }
                //plantsToCreate should now contain values that we don't have in core data
                for representation in plantsToCreate.values {
                    Plant(plantRepresentation: representation, context: context)
                }
            } catch {
                print("Error fetching plants for ids: \(error)")
            }
        }
        try CoreDataStack.shared.save()
    }
}
