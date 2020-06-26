import Foundation
import CoreData

class APIController {
    
    static let shared = APIController()
    
    // MARK: - Enums
    
    enum NetworkError: Error {
        case noIdentifier
        case otherError
        case noData
        case noDecode
        case noEncode
        case noRep
        case failedSignUp
        case failedSignIn
        case noToken
        case tryAgain
        case invalidURL
        case invalidImageData
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
    }
    
    // MARK: - Properties
    
    private let baseURL = URL(string: "https://stark-sierra-74070.herokuapp.com")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/auth/register")
    private lazy var signInURL = baseURL.appendingPathComponent("/auth/login")
    
    var bearer: Bearer?
    
    typealias NetworkCompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    // MARK: - Initializer
    
    private init() {
        
    }
    
    // MARK: - Methods
    
    func signUp(with user: UserRepresentation, completion: @escaping (Bearer?) -> Void) {
        
        /// Request URL
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        /// Username & Password -> HTTPBody
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(user)
            print(String(data: jsonData, encoding:  .utf8)!)
            request.httpBody = jsonData
            
            /// URL Data Task
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else {
                    completion(nil)
                    return
                }
                
                // Error Check
                if let error = error {
                    print("Sign Up failed with error: \(error)")
                    completion(nil)
                    return
                }
                
                // Check for Data
                guard let data = data else {
                    print("Data was not recieved")
                    completion(nil)
                    return
                }
                
                if let response = response {
                    print(response)
                }
                
                // Decode Data (Bearer Token)
                do {
                    let decoder = JSONDecoder()
                    self.bearer = try decoder.decode(Bearer.self, from: data)
                    completion(self.bearer)
                } catch {
                    print("Error decoding bearer: \(error)")
                    completion(nil)
                    return
                }
                
                //                completion(self.bearer)
            }.resume()
            
        } catch {
            print("Error signing up user: \(error)")
            completion(nil)
        }
    }
    
    func signIn(with user: UserRepresentation, completion: @escaping NetworkCompletionHandler) {
        // Creating URL Request
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Sign in failed with error: \(error)")
                    completion(.failure(.failedSignIn))
                    return
                }
                
                if let response = response {
                    print(response)
                }
                
                guard let data = data else{
                    print("Data was not recieved")
                    completion(.failure(.failedSignIn))
                    return
                }
                
                do{
                    let decoder = JSONDecoder()
                    self.bearer = try decoder.decode(Bearer.self, from: data)
                    print(self.bearer)
                    completion(.success(true))
                } catch {
                    print("Error Decoding bearer: \(error)")
                    completion(.failure(.noToken))
                    return
                }
            } .resume()
        } catch {
            print("Error encoding user: \(error)")
            completion(.failure(.failedSignIn))
        }
        
    }
    
    // Adding plants to our database / Possibly also called when updating the plant in the database
    func addPlantToDatabase(plant: Plant, completion: @escaping NetworkCompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("/plants")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        guard let bearer = bearer else {
            print("No bearer token")
            return
        }
        request.setValue("Basic \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        do {
            guard let representation = plant.plantRepresentation else {
                completion(.failure(.noRep))
                return
            }
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(representation)
            print(String(data: jsonData, encoding:  .utf8)!)
            request.httpBody = jsonData
            
        } catch {
            print("Error encoding Plant \(plant): \(error)")
            completion(.failure(.noEncode))
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(.otherError))
                print("Error putting plant to server: \(error)")
                return
            }
            
            if let response = response {
                print(response)
            }
            
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }
    
    // Fetching plants from database
    func fetchPlantsFromDatabase(completion: @escaping NetworkCompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                print("Error fetching plant(s): \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                print("No data returned by data task")
                completion(.failure(.noData))
                return
            }
            
            do {
                let plantRepresentation = Array(try JSONDecoder().decode([Int: PlantRepresentation].self, from: data).values)
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
    func deletePlantsFromDatabase(_ plant: Plant, completion: @escaping NetworkCompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent(String(plant.id)).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        guard let bearer = bearer else {
            print("No bearer token")
            return
        }
        request.setValue("Basic \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }
    
    // MARK: - Private Functions
    
    // Creating a representation of our Plant Object
    private func update(plant: Plant, with representation: PlantRepresentation) {
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
        let idsToFetch = representations.compactMap { Int16($0.id!) }
        let representationByID = Dictionary(uniqueKeysWithValues: zip(idsToFetch, representations))
        //Mutable copy of our dictonary to use for new Objects on the remote that we don't have locally
        var plantsToCreate = representationByID
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", idsToFetch)
        context.performAndWait {
            do {
                let existingPlants = try context.fetch(fetchRequest)
                for plant in existingPlants {
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
