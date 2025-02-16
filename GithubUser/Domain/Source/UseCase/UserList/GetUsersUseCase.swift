//
//  GetUsersUseCase.swift
//  Domain
//
//  Created by Bao Nguyen on 13/2/25.
//

import Combine
internal import Spyable

@Spyable(behindPreprocessorFlag: "DEBUG || TESTING", accessLevel: .public)
public protocol GetUsersUseCase {
    /// Retreive and Observe change from repository
    /// - Returns: AnyPublisher<[UserModel]>
    func invoke() -> AnyPublisher<[UserModel], Never>
}

struct DefaultGetUsersUseCase: GetUsersUseCase {
    private let githubRepository: GithubRepository

    init(githubRepository: GithubRepository) {
        self.githubRepository = githubRepository
    }

    func invoke() -> AnyPublisher<[UserModel], Never> {
        githubRepository.getUsers()
    }
}
