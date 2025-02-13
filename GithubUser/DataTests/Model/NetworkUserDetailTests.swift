//
//  NetworkUserDetailTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 13/2/25.
//

import XCTest
@testable import Data

final class NetworkUserDetailTests: XCTestCase {

    func testUserDetailDecoding() throws {
        let jsonData = Network.UserDetailFixture.user1JSON.data(using: .utf8)!

        let userDetail = try JSONDecoder().decode(Network.UserDetail.self, from: jsonData)

        XCTAssertEqual(userDetail, Network.UserDetailFixture.user1)
    }

    func testUserDetailDecodingFailsForMissingFields() throws {
        let jsonData = Network.UserDetailFixture.user1IncompleteJSON.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Network.UserDetail.self, from: jsonData))
    }

    func testUserDetailDecodingFailsForInvalidFieldTypes() throws {
        let jsonData = Network.UserDetailFixture.user1InvalidJSON.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Network.UserDetail.self, from: jsonData))
    }
}

