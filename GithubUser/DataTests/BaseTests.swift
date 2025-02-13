//
//  BaseTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 13/2/25.
//

import XCTest

class BaseTests: XCTestCase {
    func dataWithName(_ name: String, ofType: String) -> Data? {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: name, ofType: ofType) else {
            fatalError("\(name).\(ofType) not found")
        }
        return try? Data(contentsOf: URL(fileURLWithPath: pathString))
    }

}
