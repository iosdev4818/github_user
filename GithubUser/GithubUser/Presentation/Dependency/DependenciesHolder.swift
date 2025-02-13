//
//  DependenciesHolder.swift
//  GithubUser
//
//  Created by Bao Nguyen on 13/2/25.
//

import Data
import APINetwork

final class DependenciesHolder {
    static let instance = DependenciesHolder()

    private init() {}

    lazy var dependencies: Dependencies = {
        let httpClientDependencies = HttpClientDependenciesFactory.make()
        let repositoryDependencies = RepositoryDependenciesFactory.make(httpClientDependencies: httpClientDependencies)
        return DefaultDependencies(
            repositoryDependencies: repositoryDependencies)
    }()
}
