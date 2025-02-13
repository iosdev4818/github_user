//
//  GithubRemoteDataSource.swift
//  APINetwork
//
//  Created by Bao Nguyen on 12/2/25.
//
internal import Spyable

@Spyable(behindPreprocessorFlag: "DEBUG || TESTING")
protocol GithubRemoteDataSource {
    func loadUsers(limit: Int, offset: Int) async throws -> [Network.User]
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
