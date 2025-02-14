//
//  UserModelTests.swift
//  DomainTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import XCTest
@testable import Domain

class UserModelTests: XCTestCase {

    var userModel: UserModel!

    override func setUp() {
        super.setUp()
        userModel = UserModel(username: "testuser", avatarURL: "https://example.com/avatar.png", htmlURL: "https://github.com/testuser", location: "New York", follower: 100, following: 50)
    }

    override func tearDown() {
        userModel = nil
        super.tearDown()
    }

    func testUserModelInitialization() {
        XCTAssertNotNil(userModel)
        XCTAssertEqual(userModel.username, "testuser")
        XCTAssertEqual(userModel.avatarURL, "https://example.com/avatar.png")
        XCTAssertEqual(userModel.htmlURL, "https://github.com/testuser")
        XCTAssertEqual(userModel.location, "New York")
        XCTAssertEqual(userModel.follower, 100)
        XCTAssertEqual(userModel.following, 50)
    }

    func testUserModelUUID() {
        let userModel1 = UserModel(username: "user1", avatarURL: "https://example.com/avatar1.png", htmlURL: "https://github.com/user1", location: "London", follower: 200, following: 100)
        let userModel2 = UserModel(username: "user2", avatarURL: "https://example.com/avatar2.png", htmlURL: "https://github.com/user2", location: "Paris", follower: 150, following: 75)

        XCTAssertNotEqual(userModel1.id, userModel2.id)
    }
}

