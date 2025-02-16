//
//  CoreDatabaseSpy.swift
//  DataTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import CoreData
@testable import Data

final class CoreDatabaseSpy: CoreDatabase {
    private let internalPersistenContainer: NSPersistentContainer
    private let mainBackgroundContext: NSManagedObjectContext

    init(databaseName: String = "Github") {
        let managedObjectModel = CoreDatabaseModel(name: databaseName).managedObjectModel

        internalPersistenContainer = NSPersistentContainer(name: "Test", managedObjectModel: managedObjectModel)

        let description = NSPersistentStoreDescription(url: URL(fileURLWithPath: "/dev/null"))
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        internalPersistenContainer.persistentStoreDescriptions = [description]

        internalPersistenContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }

        mainBackgroundContext = internalPersistenContainer.newBackgroundContext()
        mainBackgroundContext.automaticallyMergesChangesFromParent = true
        mainBackgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }

    var persistentContainer: NSPersistentContainer {
        internalPersistenContainer
    }

    var viewContext: NSManagedObjectContext {
        internalPersistenContainer.viewContext
    }

    var currentBackgroundContext: NSManagedObjectContext {
        mainBackgroundContext
    }

    func saveContext() {
        try! viewContext.save()
    }

    func clearData() {
        for entity in persistentContainer.managedObjectModel.entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            let fetchedResults = try! viewContext.fetch(fetchRequest) as! [NSManagedObject]
            for fetchedResult in fetchedResults {
                viewContext.delete(fetchedResult)
            }
        }
        try! viewContext.save()
    }
}
