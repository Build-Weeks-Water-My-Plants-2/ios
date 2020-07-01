import Foundation
import CoreData

extension User {
    
    // MARK: - Initalizers
    
    /// Creates User with shared Managed Object Contect "moc"
    @discardableResult
    convenience init(id: String,
                     username: String,
                     password: String,
                     phoneNumber: String?,
                     avatarUrl: String?,
                     bearer: String,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.id = id
        self.username = username
        self.password = password
        self.phoneNumber = phoneNumber
        self.avatarUrl = avatarUrl
        self.bearer = bearer
    }
    
    /// Creates User from UserRepresentation Data
    @discardableResult
    convenience init?(userRepresentation: UserRepresentation,
                      context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let userId = userRepresentation.id,
            let userBearer = userRepresentation.bearer else {
                print("Error: Missing ")
                return nil
        }
        
        self.init(id: String(userId),
                  username: userRepresentation.username,
                  password: userRepresentation.password,
                  phoneNumber: userRepresentation.phoneNumber,
                  avatarUrl: userRepresentation.avatarUrl,
                  bearer: userBearer,
                  context: context)
    }
    
    // MARK: - Objects
    
    /// Object passed to Backend
    var userRepresentation: UserRepresentation? {
        guard let username = username,
            let password = password
            else {
                print("Error. Missing one (or both) of the following in the stored user: username/password")
                return nil
        }
        
        let idNumber: Int?
        if let id = id {
            idNumber = Int(id)
        } else {
            idNumber = nil
        }
        
        return UserRepresentation(id: idNumber,
                                  username: username,
                                  password: password,
                                  phoneNumber: phoneNumber,
                                  avatarUrl: avatarUrl,
                                  bearer: bearer)
    }
}
