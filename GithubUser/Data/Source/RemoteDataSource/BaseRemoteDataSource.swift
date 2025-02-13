//
//  BaseRemoteDataSource.swift
//  APINetwork
//
//  Created by Bao Nguyen on 12/2/25.
//

protocol BaseRemoteDataSource {
    func execute<T: Request>(_ request: T) async throws -> T.ResponseModelType
}

class DefaultBaseRemoteDataSource: BaseRemoteDataSource {
    private let httpClient: HTTPClient

    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    func execute<T: Request>(_ request: T) async throws -> T.ResponseModelType {
        let output = try await httpClient.execute(request: request)
        return try request.decode(output)
    }
}
