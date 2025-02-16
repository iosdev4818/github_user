//
//  UserTranslatorTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import Testing
@testable import Data

@Suite("UserTranslatorTests", .serialized)
class UserTranslatorTests: CoreDatabaseBaseTest {
    @Test func testInvokeUserWithoutUser() {
        let sut = DefaultUserTranslator()
        let actual = sut.invoke(user: nil)
        #expect(actual == nil)
    }

    @Test func testInvokeUserWithUser() {
        let user = UserFixture.user1(in: viewContext)
        let sut = DefaultUserTranslator()
        let actual = sut.invoke(user: user)
        #expect(actual != nil)
    }

    @Test func testInvokeUsersWithEmpty() {
        let sut = DefaultUserTranslator()
        let actuals = sut.invoke(users: [])
        #expect(actuals.isEmpty)
    }

    @Test func testInvokeUsersWithUsers() {
        let users = [UserFixture.user1(in: viewContext)]
        let sut = DefaultUserTranslator()
        let actuals = sut.invoke(users: users)
        #expect(actuals.count == 1)
    }
}
