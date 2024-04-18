
import Foundation
import CoreData

class ContainerManager {
    
    static let shared = ContainerManager()

    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "wishList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {
    }

}

