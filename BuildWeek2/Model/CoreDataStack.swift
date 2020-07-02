import Foundation
import CoreData

class CoreDataStack {
    
    // MARK: - Properties
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let newContainer = NSPersistentContainer(name: "UserData")
        newContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        newContainer.viewContext.automaticallyMergesChangesFromParent = true
        return newContainer
    }()

    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Methods
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var throwingError: Error?
        
        if context.hasChanges {
            context.performAndWait {
                do {
                    try context.save()
                } catch {
                    throwingError = error
                }
            }
        } else {
            print("No changes in moc to save.")
        }
        
        if let saveError = throwingError { throw saveError }
    }
}
