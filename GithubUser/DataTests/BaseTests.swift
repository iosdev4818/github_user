//
//  BaseTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 13/2/25.
//

import XCTest
import CoreData

class BaseTests: XCTestCase {
    func dataWithName(_ name: String, ofType: String) -> Data? {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: name, ofType: ofType) else {
            fatalError("\(name).\(ofType) not found")
        }
        return try? Data(contentsOf: URL(fileURLWithPath: pathString))
    }
}

class CoreDatabaseBaseTest {
    var database: CoreDatabaseSpy!

    var persistentContainer: NSPersistentContainer {
        database.persistentContainer
    }

    var viewContext: NSManagedObjectContext {
        database.viewContext
    }

    var currentBackgroundContext: NSManagedObjectContext {
        database.currentBackgroundContext
    }

    init() {
        database = CoreDatabaseSpy()
    }

    deinit {
        database.clearData()
    }
}

