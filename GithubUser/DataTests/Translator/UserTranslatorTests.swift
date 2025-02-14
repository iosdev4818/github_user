//
//  UserTranslatorTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import XCTest
@testable import Data

final class UserTranslatorTests: CoreDatabaseBaseTest {
    func testInvokeUserWithoutUser() {
        let sut = DefaultUserTranslator()
        let actual = sut.invoke(user: nil)
        XCTAssertNil(actual)
    }

    func testInvokeUserWithUser() {
        let sut = DefaultUserTranslator()
        let actual = sut.invoke(user: UserFixture.user1(in: viewContext))
        XCTAssertNotNil(actual)
    }

    func testInvokeUsersWithEmpty() {
        let sut = DefaultUserTranslator()
        let actuals = sut.invoke(users: [])
        XCTAssertTrue(actuals.isEmpty)
    }

    func testInvokeUsersWithUsers() {
        let sut = DefaultUserTranslator()
        let actuals = sut.invoke(users: [UserFixture.user1(in: viewContext)])
        XCTAssertEqual(actuals.count, 1)
    }
}
