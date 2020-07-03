import Foundation
import CoreData

public class CoreDataStack {
    // MARK: - Properties
    
    /// Shared instance of CoreDataStack
    public static let shared = CoreDataStack()
    
    /// Persistent Store & Persistent Store Coordinator
    public lazy var container: NSPersistentContainer = {
        let newContainer = NSPersistentContainer(name: "UserData")
        newContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        newContainer.viewContext.automaticallyMergesChangesFromParent = true
        return newContainer
    }()
    
    /// Managed Object Context
    // Retrive with "CoreDataStack.shared.mainContext"
    public var mainContext: NSManagedObjectContext {
        container.viewContext
    }
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Functions
    
    public func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var saveError: Error?
        
        context.performAndWait {
            do {
                try context.save()
            } catch {
                saveError = error
            }
        }
        
        if let saveError = saveError { throw saveError }
    }
}
