//
//  Dependencies.swift
//  GithubUser
//
//  Created by Bao Nguyen on 13/2/25.
//

import Domain
import Data
import APINetwork

protocol Dependencies {
    var repositoryDependencies: RepositoryDependencies { get }
}

final class DefaultDependencies: Dependencies {
    var repositoryDependencies: RepositoryDependencies

    init(repositoryDependencies: RepositoryDependencies) {
        self.repositoryDependencies = repositoryDependencies
    }
}
