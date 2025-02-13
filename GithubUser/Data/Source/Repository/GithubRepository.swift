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
    func getUserDetail(remoteId: Int) -> AnyPublisher<String, Never>
}

struct DefaultGithubRepository: GithubRepository {
    private let githubRemoteDataSource: GithubRemoteDataSource

    init(githubRemoteDataSource: GithubRemoteDataSource) {
        self.githubRemoteDataSource = githubRemoteDataSource
    }


    func loadUsers(limit: Int, offset: Int) async throws {
        // Fetch List User from remote first
        let users = try await githubRemoteDataSource.loadUsers(limit: limit, offset: offset)
        // Then upsert it into Database
    }

    func loadUserDetail(username: String) async throws {
        // Fetch User detail from remote
        let userDetail = try await githubRemoteDataSource.loadUserDetail(username: username)
        // Then upsert it into Database
    }

    func getUsers() -> AnyPublisher<[String], Never> {
        Just([])
            .eraseToAnyPublisher()
    }

    func getUserDetail(remoteId: Int) -> AnyPublisher<String, Never> {
        Just("")
            .eraseToAnyPublisher()
    }
}
