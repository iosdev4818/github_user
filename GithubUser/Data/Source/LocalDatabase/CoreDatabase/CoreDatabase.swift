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
}

final class DefaultCoreDatabase: CoreDatabase {

    // MARK: - Constants

    struct Constants {
        static let managedObjectModelDatabaseExtension = "momd"
    }

    // MARK: - Properties

    let persistentContainer: NSPersistentContainer

    // View context executed on the main queue
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Background context that exists during the app's life
    private let backgroundContext: NSManagedObjectContext
    var currentBackgroundContext: NSManagedObjectContext {
        return backgroundContext
    }

    // MARK: - Initializer
    init(databaseName: String = "Github") {
        let bundle = Bundle(for: type(of: self))
        guard let modelUrl = bundle.url(forResource: databaseName, withExtension: Constants.managedObjectModelDatabaseExtension) else {
            fatalError("[CoreDatabase] Failed to locate \(databaseName) managed object model definition")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("[CoreDatabase] Failed to initialize \(databaseName) managed object model from URL: \(modelUrl)")
        }

        persistentContainer = NSPersistentContainer(name: databaseName, managedObjectModel: managedObjectModel)

        // Load the persistent stores
        persistentContainer.loadPersistentStores { (storeDescription, error) in
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
}


