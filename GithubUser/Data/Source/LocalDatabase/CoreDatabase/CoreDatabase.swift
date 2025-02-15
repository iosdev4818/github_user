//
//  CoreDatabase.swift
//  Data
//
//  Created by Bao Nguyen on 13/2/25.
//

import CoreData

protocol CoreDatabase {
    var persistentContainer: NSPersistentContainer { get }
    var viewContext: NSManagedObjectContext { get }
    var currentBackgroundContext: NSManagedObjectContext { get }
    func saveContext()
    func clearData()
}

final class DefaultCoreDatabase: CoreDatabase {
    // MARK: - Properties

    let persistentContainer: NSPersistentContainer

    // View context executed on the main queue
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // Background context that exists during the app's life
    private let backgroundContext: NSManagedObjectContext
    var currentBackgroundContext: NSManagedObjectContext {
        backgroundContext
    }

    // MARK: - Initializer
    init(databaseName: String = "Github") {
        let managedObjectModel = CoreDatabaseModel(name: databaseName).managedObjectModel

        persistentContainer = NSPersistentContainer(name: databaseName, managedObjectModel: managedObjectModel)

        // Load the persistent stores
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        // Configure contexts
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true

        backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // MARK: - Methods

    /// Save the viewContext
    func saveContext() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func clearData() {
        currentBackgroundContext.performReset()
        viewContext.performReset()
        let persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        let storeURLs = persistentStoreCoordinator.persistentStores.compactMap { $0.url }

        persistentStoreCoordinator.persistentStores.forEach {
            do {
                try persistentStoreCoordinator.remove($0)
            } catch {
            }
        }

        deletePersistentStoreFiles(at: storeURLs)
    }
}

private extension DefaultCoreDatabase {
    private func deletePersistentStoreFiles(at urls: [URL]) {
        let fileManager = FileManager.default
        for url in urls {
            do {
                if fileManager.fileExists(atPath: url.path) {
                    try fileManager.removeItem(at: url)
                    print("Deleted store file at: \(url)")
                }
            } catch {
                print("Failed to delete store file at \(url): \(error)")
            }
        }
    }
}

class CoreDatabaseModel {
    // MARK: - Constants
    struct Constants {
        static let managedObjectModelDatabaseExtension = "momd"
    }

    private let name: String

    private lazy var bundle: Bundle = {
        Bundle(for: type(of: self))
    }()

    init(name: String) {
        self.name = name
    }

    var modelUrl: URL {
        guard let modelUrl = bundle.url(forResource: name, withExtension: Constants.managedObjectModelDatabaseExtension) else {
            fatalError("[CoreDatabaseModel] Failed to locate \(name) managed object model definition")
        }
        return modelUrl
    }

    var managedObjectModel: NSManagedObjectModel {
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("[CoreDatabaseModel] Failed to initialize \(name) managed object model from URL: \(modelUrl)")
        }
        return managedObjectModel
    }
}
