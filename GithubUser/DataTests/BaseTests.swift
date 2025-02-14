//
//  BaseTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 13/2/25.
//

import XCTest
import CoreData
@testable import Data

class BaseTests: XCTestCase {
    func dataWithName(_ name: String, ofType: String) -> Data? {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: name, ofType: ofType) else {
            fatalError("\(name).\(ofType) not found")
        }
        return try? Data(contentsOf: URL(fileURLWithPath: pathString))
    }

}

class CoreDatabaseBaseTest: BaseTests {
    var database: CoreDatabase!

    var persistentContainer: NSPersistentContainer {
        database.persistentContainer
    }

    var viewContext: NSManagedObjectContext {
        database.viewContext
    }

    var currentBackgroundContext: NSManagedObjectContext {
        database.currentBackgroundContext
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        database = CoreDatabaseSpy()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        database.clearData()
    }
}
