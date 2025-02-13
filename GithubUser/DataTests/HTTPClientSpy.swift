//
//  HTTPClientSpy.swift
//  DataTests
//
//  Created by Bao Nguyen on 13/2/25.
//

@testable import Data

class HTTPClientSpy: HTTPClient {
    var executeClosure: ((any Request) async throws -> (Data, URLResponse))!
    func execute(request: some Request) async throws -> (data: Data, response: URLResponse) {
        try await executeClosure(request)
    }
}
