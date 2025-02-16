//
//  UserDetailRequest.swift
//  Data
//
//  Created by Bao Nguyen on 12/2/25.
//


/// User detail request
final class UserDetailRequest: JSONDecodableRequest<Network.UserDetail> {

    /// Make a user detail request based on the username
    /// - Parameter username: username of user
    init(username: String) {
        super.init(
            httpMethod: .GET,
            baseEndpoint: .github,
            path: "/users/\(username)"
        )
    }
}
