//
//  NSManagedObjectContext+Extension.swift
//  Data
//
//  Created by Bao Nguyen on 13/2/25.
//

import CoreData

extension NSManagedObjectContext {
    func performReset() {
        performAndWait {
            reset()
        }
    }

    func saveChanges() throws {
        guard let persistentStoreCoordinator = persistentStoreCoordinator, !persistentStoreCoordinator.persistentStores.isEmpty else {
            assertionFailure()
            return
        }

        try performAndWait {
            if hasChanges {
                do {
                    try save()
                } catch {
                    throw error
                }
            }
        }
    }
}
