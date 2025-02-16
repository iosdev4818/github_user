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

struct DefaultBaseEndpointProvider: BaseEndpointProvider {
        /// Determine the base URL based on `BaseEndpointType`
        /// - Parameter type: BaseEndpointType
        /// - Returns: URL as string
    func endpoint(for type: BaseEndpointType) -> String {
        switch type {
        case .github:
            return "https://api.github.com"
        @unknown default:
            fatalError("Must implement all cases in BaseEndpointType: \(type)")
        }
    }
}

public struct BaseEndpointProviderFactory {
    public static func make() -> BaseEndpointProvider {
        DefaultBaseEndpointProvider()
    }
}
