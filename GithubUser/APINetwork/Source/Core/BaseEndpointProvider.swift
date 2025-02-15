//
//  BaseEndpointProvider.swift
//  APINetwork
//
//  Created by Bao Nguyen on 13/2/25.
//

import Data

struct DefaultBaseEndpointProvider: BaseEndpointProvider {
    func endpoint(for type: BaseEndpointType) -> String {
        switch type {
        case .github:
            return "https://api.github.com"
        @unknown default:
            fatalError("Must implement all cases in BaseEndpointType: \(type)")
        }
    }
}
