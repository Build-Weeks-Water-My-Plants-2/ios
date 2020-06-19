//
//  APIController.swift
//  BuildWeek2
//
//  Created by Clayton Watkins on 6/17/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

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

// Temp model for our plant so that there are no errors. Will be deleted and functions changed when CoreData has been set up
struct Plant {
    let name: String
    let identifier: UUID?
    let plantRepresntation: PlantRepresentation?
}

struct PlantRepresentation: Codable, Equatable{
    let name: String
    let identifier: UUID?
}

class APIController {
    
    // MARK: - Properties
    private let baseURL = URL(string: "URL GOES HERE")!
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    // MARK: - Initializer
    init(){
        // TODO: - Fetch plants from server
    }
    
    //MARK: - Networking Functions
    
    // Adding plants to our database / Possibly also called when updating the plant in the database
    func addPlantToDatabase(plant: Plant, completion: @escaping CompletionHandler = { _ in }){
        guard let uuid = plant.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do{
            guard let representation = plant.plantRepresntation else{
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
            // TODO - Use an do try catch to decode our object from the database and pass that into our update function so we can check
            // if we have that object saved in our persistence, if not it will be added
//            do{
//                let plantRepresentation = Array(try JSONDecoder().decode([String : PlantRepresentation].self, from: data).values)
//                try
//            } catch {
//
//            }
        }
    }
    
    // Removing plants from database
    func deletePlantsFromDatabase(_ plant: Plant, completion: @escaping CompletionHandler = { _ in }){
        guard let uuid = plant.identifier else{
            completion(.failure(.noIdentifier))
            return
        }
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
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
        // TODO: - Create Plant Representation that mimics our Plant model once it's created
    }
    
    // Creating a function that will update our Plant Representation
    private func updatePlants(with representations: [PlantRepresentation]) throws {
        // Creating a new CoreData context so that we aren't saving to the main context while calling this inside of a URLSession. Uncomment once CoreData has been established
        //let context = CoreDataStack.shared.container.newBackgroundContext()
        // Creating an array of UUIDs
        let identifiersToFetch = representations.compactMap({$0.identifier})
        let representationByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        //Creating this next variable for later use
        var plantsToCreate = representationByID
        // TODO: - Finish rest of function once CoreData has been established so that we can create a fetchRequest and an NSPredicate
    }
}
