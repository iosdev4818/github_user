//
//  GithubRemoteDataSource.swift
//  APINetwork
//
//  Created by Bao Nguyen on 12/2/25.
//
internal import Spyable

@Spyable(behindPreprocessorFlag: "DEBUG || TESTING")
protocol GithubRemoteDataSource {
    /// Get List User from remote API
    /// - Parameters:
    ///   - limit: limit item per page
    ///   - offset: start from offset
    /// - Returns: List<Network.User>
    func loadUsers(limit: Int, offset: Int) async throws -> [Network.User]

    /// Get User detail from remote API
    /// - Parameter username: username of user
    /// - Returns: Network.UserDetail
    func loadUserDetail(username: String) async throws -> Network.UserDetail
}

final class DefaultGithubRemoteDataSource: DefaultBaseRemoteDataSource, GithubRemoteDataSource {
    func loadUsers(limit: Int, offset: Int) async throws -> [Network.User] {
        try await execute(UserRequest(limit: limit, offset: offset))
    }

    func loadUserDetail(username: String) async throws -> Network.UserDetail {
        try await execute(UserDetailRequest(username: username))
    }

}
