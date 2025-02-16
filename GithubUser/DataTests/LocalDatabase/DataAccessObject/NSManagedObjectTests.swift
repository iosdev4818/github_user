//
//  NSManagedObjectTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import CoreData
@testable import Data

extension NSManagedObject {
    static func instance(in context: NSManagedObjectContext? = nil) -> Self {
        Self(entity: Self.entity(), insertInto: context)
    }
}
