//
//  DefaultBaseEndpointProviderTests.swift
//  APINetworkTests
//
//  Created by Bao Nguyen on 13/2/25.
//

import XCTest
@testable import APINetwork

final class DefaultBaseEndpointProviderTests: XCTestCase {
    func test() {
        let sut = DefaultBaseEndpointProvider()
        XCTAssertEqual(sut.endpoint(for: .github), "https://api.github.com")
    }

}
