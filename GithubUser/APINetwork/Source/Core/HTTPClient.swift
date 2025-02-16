//
//  HTTPClient.swift
//  APINetwork
//
//  Created by Bao Nguyen on 12/2/25.
//

import Data

struct DefaultHTTPClient {
    private let baseEndpointProvider: BaseEndpointProvider
    private let session: URLSession

    init(
        baseEndpointProvider: BaseEndpointProvider,
        session: URLSession
    ) {
        self.baseEndpointProvider = baseEndpointProvider
        self.session = session
    }
}

// MARK: - HTTPClient
extension DefaultHTTPClient: HTTPClient {

    /// Conform HTTPClient protocol
    /// - Parameter request: api request information
    /// - Returns: data response and url response
    func execute(request: some Request) async throws -> (data: Data, response: URLResponse) {
        try await internalExecute(request: request)
    }
}

private extension DefaultHTTPClient {

    /// Create a `URLRequest` from the `Request` protocol and execute it
    /// - Parameter request: Request data
    /// - Returns: data response and url response
    func internalExecute(request: some Request) async throws -> (data: Data, response: URLResponse) {
        do {
            let output = try await checkCacheAndExecute(
                urlRequest: try request.toUrlRequest(baseEndpointProvider: baseEndpointProvider),
                uuid: UUID()
            )
            return output
        } catch {
            throw error
        }
    }

    /// Check if the cache exists; if it does, retrieve from the cache; otherwise, execute a remote request
    /// - Parameters:
    ///   - urlRequest: url request
    ///   - uuid: Identify each request
    /// - Returns: response data and url response
    func checkCacheAndExecute( urlRequest: URLRequest, uuid: UUID) async throws -> (data: Data, response: URLResponse) {
        if let cachedRequest = getCached(request: urlRequest) {
            return cachedRequest
        }

        let output = try await execute(
            request: urlRequest,
            uuid: uuid
        )
        return output
    }

    /// Check and retrieve from the cache if it exists
    /// - Parameter request: url for request
    /// - Returns: response data and url response
    func getCached(request: URLRequest) -> (data: Data, response: URLResponse)? {
        // Skip cached responses
        if request.cachePolicy == .returnCacheDataElseLoad, let cachedResponse = session.configuration.urlCache?.cachedResponse(for: request) {
            return (cachedResponse.data, cachedResponse.response)
        }
        return nil
    }

    /// Perform a URLRequest and receive the response data.
    /// - Parameters:
    ///   - request: URL request
    ///   - uuid: Identify each request
    /// - Returns: response data and url response
    func execute(request: URLRequest, uuid: UUID) async throws -> (data: Data, response: URLResponse) {
        var output: (data: Data, response: URLResponse)?
        do {
            output = try await session.data(for: request)
        } catch {
            throw error
        }

        guard let output else {
            throw URLError(.badServerResponse)
        }

        return output
    }
}
