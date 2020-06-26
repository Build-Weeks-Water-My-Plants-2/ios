import Foundation
import CoreData

extension User {
    
    // MARK: - Properties
    
    /// Object passed to Backend
    var userRepresentation: UserRepresentation? {
        guard let username = username,
            let password = password,
            let bearer = bearer
            else {
                print("Error creating UserRepresentation for backend.")
                return nil
        }
        
        return UserRepresentation(id: Int(id),
                                  username: username,
                                  password: password,
                                  phoneNumber: phoneNumber,
                                  avatarUrl: avatarUrl,
                                  bearer: bearer)
    }
    
    // MARK: - Initalizers
    
    /// Creates User with the same Managed Object Context "moc" -> Local -> CoreData
    @discardableResult convenience init(id: Int16,
                                        username: String,
                                        password: String,
                                        phoneNumber: String,
                                        avatarUrl: String,
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
    
    /// Creates User from UserRepresentation Data (Backend Data) -> CoreData
    @discardableResult
    convenience init?(userRepresentation: UserRepresentation,
                      context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(id: Int16(userRepresentation.id ?? 1),
                  username: userRepresentation.username,
                  password: userRepresentation.password,
                  phoneNumber: userRepresentation.phoneNumber ?? "",
                  avatarUrl: userRepresentation.avatarUrl ?? "",
                  bearer: userRepresentation.bearer ?? "",
                  context: context)
    }
}
