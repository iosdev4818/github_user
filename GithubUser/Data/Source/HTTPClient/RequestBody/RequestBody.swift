//
//  RequestBody.swift
//  APINetwork
//
//  Created by Bao Nguyen on 12/2/25.
//

internal import Spyable

@Spyable
public protocol RequestBody {
    var contentType: String { get }
    func encode() throws -> Data
}
