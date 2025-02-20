//
//  GetUserDetailUseCase.swift
//  Domain
//
//  Created by Bao Nguyen on 13/2/25.
//

import Combine
internal import Spyable

@Spyable(behindPreprocessorFlag: "DEBUG || TESTING", accessLevel: .public)
public protocol GetUserDetailUseCase {
    /// Get user information from repository
    /// - Parameter username: username of user
    /// - Returns: AnyPublisher<UserModel?>
    func invoke(username: String) -> AnyPublisher<UserModel?, Never>
}

struct DefaultGetUserDetailUseCase: GetUserDetailUseCase {
    private let githubRepository: GithubRepository

    init(githubRepository: GithubRepository) {
        self.githubRepository = githubRepository
    }

    func invoke(username: String) -> AnyPublisher<UserModel?, Never> {
        githubRepository
            .getUserDetail(username: username)
    }
}
