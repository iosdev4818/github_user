//
//  BaseEndpointProvider.swift
//  APINetwork
//
//  Created by Bao Nguyen on 12/2/25.
//

internal import Spyable

public enum BaseEndpointType: Equatable {
    case github
}

@Spyable(accessLevel: .public)
public protocol BaseEndpointProvider {
    func endpoint(for type: BaseEndpointType) -> String
}
