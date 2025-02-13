//
//  UserRequestTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 13/2/25.
//

import XCTest
@testable import Data

final class UserRequestTests: BaseTests {
    func testParameters() {
        let sut = UserRequest(limit: 0, offset: 20)
        
        XCTAssertEqual(sut.httpMethod, .GET)
        XCTAssertEqual(sut.baseEndpoint, .github)
        XCTAssertEqual(sut.path, "/users")
        XCTAssertEqual(sut.queryParameters, [
            URLQueryItem(name: "per_page", value: String(0)),
            URLQueryItem(name: "since", value: String(20))
        ])
        XCTAssertNil(sut.percentEncodedPath)
        XCTAssertNil(sut.body)
    }

    func testDecodeWithUserResponse() async throws {
        let output = (data: self.dataWithName("github_users_response", ofType: "json")!, response: HTTPURLResponse())

        let sut = UserRequest(limit: 2, offset: 0)

        let users = try sut.decode(output)

        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users, [
            Network.UserFixture.user1,
            Network.UserFixture.user2
        ])
    }

    func testDecodeWithEmptyResponse() async throws {
        let output = (data: self.dataWithName("github_users_empty_response", ofType: "json")!, response: HTTPURLResponse())

        let sut = UserRequest(limit: 2, offset: 0)

        let users = try sut.decode(output)

        XCTAssertTrue(users.isEmpty)
    }

}
