//
//  HTTPClient.swift
//  APINetwork
//
//  Created by Bao Nguyen on 12/2/25.
//

import Data

final class DefaultHTTPClient {
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
    func execute(request: some Request) async throws -> (data: Data, response: URLResponse) {
        try await internalExecute(request: request)
    }
}

private extension DefaultHTTPClient {
    func internalExecute(request: some Request) async throws -> (data: Data, response: URLResponse) {
        do {
            let output = try await checkCacheAndExecute(urlRequest: try configure(request: request), uuid: UUID())
            return output

        } catch {
            throw error
        }
    }

    func configure(request: some Request) throws -> URLRequest {
        try request.toUrlRequest(baseEndpointProvider: baseEndpointProvider)
    }

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

    func getCached(request: URLRequest) -> (data: Data, response: URLResponse)? {
        // Skip cached responses
        if request.cachePolicy == .returnCacheDataElseLoad, let cachedResponse = session.configuration.urlCache?.cachedResponse(for: request) {
            return (cachedResponse.data, cachedResponse.response)
        }
        return nil
    }

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
