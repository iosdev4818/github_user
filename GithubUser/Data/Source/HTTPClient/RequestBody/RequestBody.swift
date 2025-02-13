//
//  RequestBody.swift
//  APINetwork
//
//  Created by Bao Nguyen on 12/2/25.
//

public protocol RequestBody {
    var contentType: String { get }
    func encode() throws -> Data
}
