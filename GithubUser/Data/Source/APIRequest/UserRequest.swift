//
//  UserRequest.swift
//  Data
//
//  Created by Bao Nguyen on 12/2/25.
//

final class UserRequest: JSONDecodableRequest<[Network.User]> {
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
