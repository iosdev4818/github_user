//
//  NSManagedObjectTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import CoreData
@testable import Data

extension NSManagedObject {
    convenience init(using usedContext: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext)!
        self.init(entity: entity, insertInto: usedContext)
    }
}
