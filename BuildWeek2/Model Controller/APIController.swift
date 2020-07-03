import Foundation
import CoreData

class APIController {
   static let shared = APIController(session: URLSession.shared)
   
   // MARK: - Enums
   
   enum NetworkError: Error {
      case noIdentifier
      case otherError
      case noData
      case noDecode
      case noEncode
      case noRepresentation
      case failedSignUp
      case failedSignIn
      case noToken
      case tryAgain
      case invalidURL
      case invalidImageData
      case emptyPassword
      case emptyUser
      case idIsNotEmptyForNewPlant
   }
   
   enum HTTPMethod: String {
      case get = "GET"
      case put = "PUT"
      case post = "POST"
      case delete = "DELETE"
   }
   
   // MARK: - Properties
   
   private let baseURL = URL(string: "https://stark-sierra-74070.herokuapp.com")!
   private lazy var signUpURL = baseURL.appendingPathComponent("/auth/register")
   private lazy var signInURL = baseURL.appendingPathComponent("/auth/login")
   
   var bearer: Bearer?
   var session: URLSessionProtocol
   
   typealias NetworkCompletionHandler = (Result<Bool, NetworkError>) -> Void
   
   init(session: URLSessionProtocol) {
      self.session = session
   }
   
   // MARK: - Methods
   
   func signUp(with user: UserRepresentation, completion: @escaping (Bearer?) -> Void) {
      // Request URL
      var request = URLRequest(url: signUpURL)
      request.httpMethod = HTTPMethod.post.rawValue
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      // Username & Password -> HTTPBody
      let encoder = JSONEncoder()
      
      do {
         request.httpBody = try encoder.encode(user)
      } catch {
         print("Error signing up user: \(error)")
         completion(nil)
         return
      }
      
      let dataTask = session.testableDataTask(with: request) { [weak self] data, response, error in
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
      }
      
      dataTask.resume()
   }
   
   func signIn(with user: UserRepresentation, completion: @escaping NetworkCompletionHandler) {
      // Creating URL Request
      var request = URLRequest(url: signInURL)
      request.httpMethod = HTTPMethod.post.rawValue
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      if user.password.isEmpty {
         completion(.failure(.emptyPassword))
         return
      }
      
      if user.username.isEmpty {
         completion(.failure(.emptyUser))
         return
      }
      
      let encoder = JSONEncoder()
      
      do {
         request.httpBody = try encoder.encode(user)
      } catch {
         print("Error encoding user: \(error)")
         completion(.failure(.failedSignIn))
         return
      }
      
      let dataTask = session.testableDataTask(with: request) { (data, response, error) in
         if let error = error {
            print("Sign in failed with error: \(error)")
            completion(.failure(.failedSignIn))
            return
         }
         
         guard let data = data else{
            print("Data was not recieved")
            completion(.failure(.failedSignIn))
            return
         }
         
         do{
            let decoder = JSONDecoder()
            self.bearer = try decoder.decode(Bearer.self, from: data)
            completion(.success(true))
         } catch {
            print("Error Decoding bearer: \(error)")
            completion(.failure(.noToken))
            return
         }
      }
      
      dataTask.resume()
   }
   
   // Adding plants to our database / Possibly also called when updating the plant in the database
   func addPlantToDatabase(plantRepresentation: PlantRepresentation, completion: NetworkCompletionHandler? = nil) {
      let requestURL = baseURL.appendingPathComponent("/plants/")
      var request = URLRequest(url: requestURL)
      request.httpMethod = HTTPMethod.post.rawValue
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      guard plantRepresentation.id == nil else {
         completion?(.failure(.idIsNotEmptyForNewPlant))
         return
      }
      
      guard let bearer = bearer else {
         print("No bearer token")
         completion?(.failure(.noToken))
         return
      }
            
      request.setValue("Basic \(bearer.token)", forHTTPHeaderField: "Authorization")
      let encoder = JSONEncoder()

      do {
         request.httpBody = try encoder.encode(plantRepresentation)
      } catch {
         print("Error encoding Plant \(plantRepresentation): \(error)")
         completion?(.failure(.noEncode))
         return
      }
      
      let dataTask = session.testableDataTask(with: request) { data, response, error in
         if let error = error {
            completion?(.failure(.otherError))
            print("Error putting plant to server: \(error)")
            return
         }
         
         DispatchQueue.main.async {
            completion?(.success(true))
         }
      }
      
      dataTask.resume()
   }
   
   // Fetching plants from database
   func fetchPlantsFromDatabase(completion: ((Result<[PlantRepresentation], NetworkError>) -> Void)? = nil) {
      let url = baseURL.appendingPathComponent("/plants")
      var request = URLRequest(url: url)
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpMethod = HTTPMethod.get.rawValue
      
      guard let bearer = bearer else {
         print("No bearer token")
         completion?(.failure(.noToken))
         return
      }
      
      request.setValue("Basic \(bearer.token)", forHTTPHeaderField: "Authorization")
            
      let dataTask = session.testableDataTask(with: request) { data, response, error in
         if let error = error {
            print("Error fetching plant(s): \(error)")
            completion?(.failure(.otherError))
            return
         }
         
         guard let data = data else {
            print("No data returned by data task")
            completion?(.failure(.noData))
            return
         }
         
         let decoder = JSONDecoder()
         decoder.keyDecodingStrategy = .convertFromSnakeCase
         
         do {
            let plantRepresentation = try decoder.decode([PlantRepresentation].self, from: data)
            completion?(.success(plantRepresentation))
            return
         } catch {
            print("Error decoding plant representation: \(error)")
            completion?(.failure(.noDecode))
            return
         }
      }
      
      dataTask.resume()
   }
   
   // Removing plants from database
   func deletePlantsFromDatabase(_ plantRepresentation: PlantRepresentation, completion: NetworkCompletionHandler? = nil) {
      guard let plantId = plantRepresentation.id else {
         completion?(.failure(.noIdentifier))
         return
      }
            
      let requestURL = baseURL.appendingPathComponent("\(plantId)").appendingPathExtension("json")
      var request = URLRequest(url: requestURL)
      request.httpMethod = "DELETE"
      
      guard let bearer = bearer else {
         print("No bearer token")
         completion?(.failure(.noToken))
         return
      }
      
      request.setValue("Basic \(bearer.token)", forHTTPHeaderField: "Authorization")
      
      let dataTask = session.testableDataTask(with: request) { _, _, _ in
         DispatchQueue.main.async {
            completion?(.success(true))
         }
      }
      
      dataTask.resume()
   }
}
