//
//  NetworkUserTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 13/2/25.
//

import XCTest

@testable import Data

final class NetworkUserTests: XCTestCase {

    func testUserDecoding() throws {
        let jsonData = Network.UserFixture.user1JSON.data(using: .utf8)!

        let user = try JSONDecoder().decode(Network.User.self, from: jsonData)

        XCTAssertEqual(user, Network.UserFixture.user1)
    }

    func testUserDecodingFailsForInvalidJSON() throws {
        let jsonData = Network.UserFixture.user1InvalidJSON.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Network.User.self, from: jsonData))
    }
}

