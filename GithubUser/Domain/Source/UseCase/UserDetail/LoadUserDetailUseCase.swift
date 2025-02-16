//
//  LoadUserDetailUseCase.swift
//  Domain
//
//  Created by Bao Nguyen on 13/2/25.
//

internal import Spyable

@Spyable(behindPreprocessorFlag: "DEBUG || TESTING", accessLevel: .public)
public protocol LoadUserDetailUseCase {
    /// Interact with repository to load user detail from remote datasource
    /// - Parameter username: username of user
    func invoke(_ username: String) async throws
}

struct DefaultLoadUserDetailUseCase: LoadUserDetailUseCase {
    private let githubRepository: GithubRepository

    init(githubRepository: GithubRepository) {
        self.githubRepository = githubRepository
    }

    func invoke(_ username: String) async throws {
        try await githubRepository.loadUserDetail(username: username)
    }
}
