//
//  LoadUsersUseCase.swift
//  Domain
//
//  Created by Bao Nguyen on 13/2/25.
//

internal import Spyable

@Spyable(behindPreprocessorFlag: "DEBUG || TESTING", accessLevel: .public)
public protocol LoadUsersUseCase {
    func shouldInvoke(at index: Int) -> Bool
    func invoke(at index: Int) async throws
}

final class DefaultLoadUsersUseCase: LoadUsersUseCase {
    struct Constants {
        static let pageSize: Int = 20
    }

        // Set of page
    private var usersQueue = Set<Int>()

    private let githubRepository: GithubRepository

    init(githubRepository: GithubRepository) {
        self.githubRepository = githubRepository
    }

    func shouldInvoke(at index: Int) -> Bool {
        let usersCount = githubRepository.getUsersCount()
        return ((index == 0 && usersCount == 0)
                || (index + 1) == usersCount)
        && !usersQueue.contains(index)
    }

    func invoke(at index: Int) async throws {
        do {
            usersQueue.insert(index)
            let offset = (index + 1) / Constants.pageSize * Constants.pageSize
            try await githubRepository.loadUsers(limit: Constants.pageSize, offset: offset)
        } catch {
            usersQueue.remove(index)
            throw error
        }
    }
}
