//
//  DIContainer.swift
//  GithubUser
//
//  Created by Bao Nguyen on 13/2/25.
//

import Domain
import Data
import APINetwork

final class DIContainer {
    static let instance = DIContainer()

    private init() {}

    lazy var dependencies: Dependencies = {
        let httpClientDependencies = HttpClientDependenciesFactory.make()
        let repositoryDependencies = RepositoryDependenciesFactory.make(httpClientDependencies: httpClientDependencies)
        let useCaseDependencies = UseCaseDependenciesFactory.make(repositoryDependencies: repositoryDependencies)

        return DefaultDependencies(
            useCaseDependencies: useCaseDependencies,
            repositoryDependencies: repositoryDependencies,
            httpClientDependencies: httpClientDependencies
        )
    }()
}
