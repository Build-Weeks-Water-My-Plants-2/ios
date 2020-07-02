import Foundation

class UserController {
    
    static var shared = UserController()
    
    // MARK: - Enums
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
    }
    
    // MARK: - Properties
    
    let moc = CoreDataStack.shared.mainContext
    
    private let baseURL = URL(string: "https://stark-sierra-74070.herokuapp.com")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/auth/register")
    private lazy var signInURL = baseURL.appendingPathComponent("/auth/login")
    
    var bearer: Bearer?
    
    // MARK: - Initializer
    
    private init() {
    }
    
    // MARK: - Methods
    
    func signUp(userRep: UserRepresentation, completion: @escaping (Bool, Bearer?) -> Void) {
        
        /// Request URL
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        /// Username & Password -> HTTPBody
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(userRep)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
        } catch {
            print("Error encoding request body: \(error)")
            completion(false, nil)
        }
        
        /// URL Data Task
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Error Check
            if let error = error {
                print("Sign Up failed with error: \(error)")
                completion(false, nil)
                return
            }
            
            // Check for Data
            guard let data = data else {
                print("Data was not recieved")
                completion(false, nil)
                return
            }
            
            if let response = response {
                print(response)
            }
            
            // Decode Data (Bearer Token)
            do {
                let decoder = JSONDecoder()
                self.bearer = try decoder.decode(Bearer.self, from: data)
                completion(true, self.bearer)
            } catch {
                print("Error decoding bearer: \(error)")
                completion(false, nil)
                return
            }
        }.resume()
    }
    
    func signIn(user: UserRepresentation, completion: () -> Void) {
        
    }
    
    //
    //    func signIn(with user: UserRepresentation, completion: () -> ()) {
    //        // Creating URL Request
    //        var request = URLRequest(url: signInURL)
    //        request.httpMethod = HTTPMethod.post.rawValue
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        do {
    //            let encoder = JSONEncoder()
    //            let jsonData = try encoder.encode(user)
    //            request.httpBody = jsonData
    //
    //            URLSession.shared.dataTask(with: request) { data, response, error in
    //                if let error = error {
    //                    print("Sign in failed with error: \(error)")
    //                    completion()
    //                    return
    //                }
    //
    //                if let response = response {
    //                    print(response)
    //                }
    //
    //                guard let data = data else {
    //                    print("Data was not recieved")
    //                    completion()
    //                    return
    //                }
    //
    //                do {
    //                    let decoder = JSONDecoder()
    //                    self.bearer = try decoder.decode(Bearer.self, from: data)
    //                    print(self.bearer)
    //                    completion(.success(true))
    //                } catch {
    //                    print("Error Decoding bearer: \(error)")
    //                    completion(.failure(.noToken))
    //                    return
    //                }
    //            } .resume()
    //        } catch {
    //            print("Error encoding user: \(error)")
    //            completion(.failure(.failedSignIn))
    //        }
    //    }
}
