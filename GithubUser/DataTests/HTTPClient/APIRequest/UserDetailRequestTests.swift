//
//  UserDetailRequestTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 13/2/25.
//

import XCTest
@testable import Data

final class UserDetailRequestTests: BaseTests {
    func test() {
        let sut = UserDetailRequest(username: "test")
        XCTAssertEqual(sut.httpMethod, .GET)
        XCTAssertEqual(sut.baseEndpoint, .github)
        XCTAssertEqual(sut.path, "/users/test")
        XCTAssertNil(sut.queryParameters)
        XCTAssertNil(sut.percentEncodedPath)
        XCTAssertNil(sut.body)
        XCTAssertNil(sut.timeoutInterval)
        XCTAssertNil(sut.cachePolicy)
    }

    func testDecodeWithUserResponse() async throws {
        let output = (data: self.dataWithName("github_user_detail_response", ofType: "json")!, response: HTTPURLResponse())

        let sut = UserDetailRequest(username: "test")

        let user = try sut.decode(output)

        XCTAssertEqual(user, Network.UserDetailFixture.user1)
    }

}
