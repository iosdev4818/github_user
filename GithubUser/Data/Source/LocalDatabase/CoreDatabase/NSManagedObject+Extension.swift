//
//  NSManagedObject+Extension.swift
//  Data
//
//  Created by Bao Nguyen on 16/2/25.
//

import CoreData

extension NSManagedObject {
    /** Delete objects matching given predicate from given context */
    static func delete(using predicate: NSPredicate? = nil, in context: NSManagedObjectContext) throws {
        try context.performAndWait {
            let fetchRequest = Self.fetchRequest()
            fetchRequest.predicate = predicate

            guard let results = try context.fetch(fetchRequest) as? [Self] else {
                return
            }

            results.forEach { context.delete($0) }
        }
    }
}
