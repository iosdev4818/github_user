//
//  UseCaseDependencies.swift
//  Domain
//
//  Created by Bao Nguyen on 13/2/25.
//

public protocol UseCaseDependencies {
    var getUsers: GetUsersUseCase { get }
    var getUserDetail: GetUserDetailUseCase { get }
    var loadUsers: LoadUsersUseCase { get }
    var loadUserDetail: LoadUserDetailUseCase { get }
}

final class DefaultUseCaseDependencies: UseCaseDependencies {
    private let repositoryDependencies: RepositoryDependencies

    init(repositoryDependencies: RepositoryDependencies) {
        self.repositoryDependencies = repositoryDependencies
    }

    lazy var getUsers: GetUsersUseCase = {
        DefaultGetUsersUseCase(
            githubRepository: repositoryDependencies.githubRepository
        )
    }()

    lazy var getUserDetail: GetUserDetailUseCase = {
        DefaultGetUserDetailUseCase(
            githubRepository: repositoryDependencies.githubRepository
        )
    }()

    lazy var loadUsers: LoadUsersUseCase = {
        DefaultLoadUsersUseCase(
            githubRepository: repositoryDependencies.githubRepository
        )
    }()

    lazy var loadUserDetail: LoadUserDetailUseCase = {
        DefaultLoadUserDetailUseCase(
            githubRepository: repositoryDependencies.githubRepository
        )
    }()
}

public final class UseCaseDependenciesFactory {
    public static func make(repositoryDependencies: RepositoryDependencies) -> UseCaseDependencies {
        DefaultUseCaseDependencies(
            repositoryDependencies: repositoryDependencies
        )
    }
}
