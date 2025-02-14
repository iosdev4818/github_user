//
//  GithubRepository.swift
//  Domain
//
//  Created by Bao Nguyen on 13/2/25.
//

import Combine
internal import Spyable

@Spyable(behindPreprocessorFlag: "DEBUG || TESTING", accessLevel: .public)
public protocol GithubRepository {
    func loadUsers(limit: Int, offset: Int) async throws
    func loadUserDetail(username: String) async throws
    func getUsers() -> AnyPublisher<[UserModel], Never>
    func getUserDetail(username: String) -> AnyPublisher<UserModel?, Never>
    func getUsersCount() -> Int
}
