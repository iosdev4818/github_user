//
//  JSONDecodableRequestTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 13/2/25.
//

import XCTest
@testable import Data

final class JSONDecodableRequestTests: XCTestCase {

    func test() async throws {
        let sut = JSONDecodableRequest<[String]>(httpMethod: .GET, baseEndpoint: .github, path: "/users")

        XCTAssertEqual(sut.httpMethod, .GET)
        XCTAssertEqual(sut.baseEndpoint, .github)
        XCTAssertEqual(sut.path, "/users")
        XCTAssertNil(sut.percentEncodedPath)
        XCTAssertNil(sut.queryParameters)
        XCTAssertNil(sut.body)
        XCTAssertNil(sut.cachePolicy)
        XCTAssertNil(sut.cachePolicy)

        let output = (data: "[]".data(using: .utf8)!, response: HTTPURLResponse())

        let result = try sut.decode(output)

        XCTAssertEqual(result, [])
    }

}
