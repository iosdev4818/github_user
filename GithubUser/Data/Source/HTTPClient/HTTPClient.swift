//
//  HTTPClient.swift
//  Data
//
//  Created by Bao Nguyen on 12/2/25.
//
internal import Spyable

public protocol HTTPClient {
    func execute(request: some Request) async throws -> (data: Data, response: URLResponse)
}
