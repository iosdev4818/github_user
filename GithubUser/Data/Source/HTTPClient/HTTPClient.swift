//
//  HTTPClient.swift
//  Data
//
//  Created by Bao Nguyen on 12/2/25.
//

public protocol HTTPClient {
    func execute(request: some Request) async throws -> (data: Data, response: URLResponse)
}
