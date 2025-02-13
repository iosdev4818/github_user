//
//  UserDetailRequest.swift
//  Data
//
//  Created by Bao Nguyen on 12/2/25.
//

final class UserDetailRequest: JSONDecodableRequest<Network.UserDetail> {
    init(username: String) {
        super.init(
            httpMethod: .GET,
            baseEndpoint: .github,
            path: "/users/\(username)"
        )
    }
}
