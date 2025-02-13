//
//  JsonBodyTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 13/2/25.
//

import XCTest
@testable import Data

final class JsonBodyTests: XCTestCase {
    func testJsonBody() {
        struct TestModel: Encodable {
            let id: String
        }
        let test = TestModel(id: "100")

        let sut = JsonBody(test)

        XCTAssertEqual(sut.contentType, "application/json; charset=utf-8")
        XCTAssertEqual(try sut.encode(), try test.toJSONData())
    }
}
