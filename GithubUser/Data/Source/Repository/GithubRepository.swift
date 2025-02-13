//
//  GithubRepository.swift
//  Data
//
//  Created by Bao Nguyen on 12/2/25.
//
internal import Spyable
import Combine

@Spyable(behindPreprocessorFlag: "DEBUG || TESTING")
public protocol GithubRepository {
    func loadUsers(limit: Int, offset: Int) async throws
    func loadUserDetail(username: String) async throws
    func getUsers() -> AnyPublisher<[String], Never>
}

struct DefaultGithubRepository: GithubRepository {
    private let githubRemoteDataSource: GithubRemoteDataSource

    init(githubRemoteDataSource: GithubRemoteDataSource) {
        self.githubRemoteDataSource = githubRemoteDataSource
    }

    func loadUsers(limit: Int, offset: Int) async throws {
        let users = try await githubRemoteDataSource.loadUsers(limit: limit, offset: offset)
        debugPrint(users)
    }

    func loadUserDetail(username: String) async throws {
        let userDetail = try await githubRemoteDataSource.loadUserDetail(username: username)
        debugPrint(userDetail)
    }

    func getUsers() -> AnyPublisher<[String], Never> {
        Just([])
            .eraseToAnyPublisher()
    }
}
