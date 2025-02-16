//
//  UserRequest.swift
//  Data
//
//  Created by Bao Nguyen on 12/2/25.
//

/// Users list request
final class UserRequest: JSONDecodableRequest<[Network.User]> {

    /// Make UserRequest based on limit and offset
    /// - Parameters:
    ///   - limit: item per request
    ///   - offset: offset for items
    init(limit: Int, offset: Int) {
        super.init(
            httpMethod: .GET,
            baseEndpoint: .github,
            path: "/users",
            queryParameters: [
                URLQueryItem(name: "per_page", value: String(limit)),
                URLQueryItem(name: "since", value: String(offset))
            ]
        )
    }
}
