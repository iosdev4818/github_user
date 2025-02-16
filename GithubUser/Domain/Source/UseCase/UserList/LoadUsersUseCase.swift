//
//  LoadUsersUseCase.swift
//  Domain
//
//  Created by Bao Nguyen on 13/2/25.
//

internal import Spyable

@Spyable(behindPreprocessorFlag: "DEBUG || TESTING", accessLevel: .public)
public protocol LoadUsersUseCase {
    /// Check whether to invoke for the item at a specific index
    /// - Parameter index: index of user
    /// - Returns: true/false
    func shouldInvoke(at index: Int) -> Bool

    /// Interact with repository to load the remote user
    /// - Parameter index: index of current user
    func invoke(at index: Int) async throws

    /// Clear all Queue and User data
    func invalidate() throws
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

    func invalidate() throws {
        usersQueue.removeAll()
        try githubRepository.deleteUsers()
    }
}
