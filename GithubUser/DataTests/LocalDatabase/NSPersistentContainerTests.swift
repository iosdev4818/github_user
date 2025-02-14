//
//  NSPersistentContainerTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import CoreData

extension NSPersistentContainer {

    enum NSPersistentContainerError: Error {
        case noManagedObjectContextFound
    }

    func saveContext(of managedObjects: [NSManagedObject]) throws {
        for managedObject in managedObjects {
            guard let context = managedObject.managedObjectContext else {
                throw NSPersistentContainerError.noManagedObjectContextFound
            }
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            try context.save()
        }
    }
}
