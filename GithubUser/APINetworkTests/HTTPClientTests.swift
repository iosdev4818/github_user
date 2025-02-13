//
//  HTTPClientTests.swift
//  APINetworkTests
//
//  Created by Bao Nguyen on 13/2/25.
//

import XCTest
@testable import APINetwork
@testable import Data

final class HTTPClientTests: XCTestCase {
    var urlSession: URLSession!
    var baseEndpointProvider: BaseEndpointProviderSpy!

    private let baseEndpoint = "https://example.com"
    private let baseURL = URL(string: "https://example.com/users")!

    override func setUpWithError() throws {
        try super.setUpWithError()
        URLProtocol.registerClass(URLProtocolMock.self)
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolMock.self]
        urlSession = URLSession(configuration: configuration)

        baseEndpointProvider = BaseEndpointProviderSpy()
        baseEndpointProvider.endpointForClosure = { _ in
            return self.baseEndpoint
        }
    }

    override func tearDown() {
        super.tearDown()
        URLProtocolMock.requestHandler = nil
        URLProtocol.unregisterClass(URLProtocolMock.self)
    }

    func testExecute() async throws {
        let jsonString = """
                     {
                        "field1": "field 1",
                        "field2": "field 2",
                     }
                     """
        let responseData = jsonString.data(using: .utf8)
        let request = RequestSpy<String>()
        request.httpMethod = .GET
        request.baseEndpoint = .github
        request.path = "/users"

        URLProtocolMock.requestHandler = { urlRequest in
            guard let url = urlRequest.url, url == self.baseURL else {
                throw URLError(.badURL)
            }

            XCTAssertEqual(urlRequest, try request.toUrlRequest(baseEndpointProvider: self.baseEndpointProvider))

            let response = HTTPURLResponse(url: self.baseURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, responseData)
        }

        let sut = DefaultHTTPClient(baseEndpointProvider: baseEndpointProvider, session: urlSession)

        let output = try await sut.execute(request: request)

        XCTAssertNotNil(output.data)
        XCTAssertEqual(responseData, output.data)
        XCTAssertNotNil(output.response)
        let httpUrlResponse = output.response as? HTTPURLResponse
        XCTAssertNotNil(httpUrlResponse)
        XCTAssertEqual(httpUrlResponse!.statusCode, 200)
    }

    func testExecuteWhenError() async throws {
        let request = RequestSpy<String>()
        request.httpMethod = .GET
        request.baseEndpoint = .github
        request.path = "/users"

        URLProtocolMock.requestHandler = { urlRequest in
            XCTAssertEqual(urlRequest, try request.toUrlRequest(baseEndpointProvider: self.baseEndpointProvider))
            throw URLError(.badURL)
        }

        let sut = DefaultHTTPClient(baseEndpointProvider: baseEndpointProvider, session: urlSession)

        do {
            _ = try await sut.execute(request: request)
            XCTFail("Must not call")
        } catch let error {
            XCTAssertEqual((error as! URLError).code, URLError(.badURL).code)
        }
    }
}
