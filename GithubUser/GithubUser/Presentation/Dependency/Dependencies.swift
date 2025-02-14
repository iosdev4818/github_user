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
    var useCaseDependencies: UseCaseDependencies { get }
    var repositoryDependencies: RepositoryDependencies { get }
    var httpClientDependencies: HttpClientDependencies { get }
}

final class DefaultDependencies: Dependencies {
    var useCaseDependencies: UseCaseDependencies
    var repositoryDependencies: RepositoryDependencies
    var httpClientDependencies: HttpClientDependencies
    
    init(
        useCaseDependencies: UseCaseDependencies,
        repositoryDependencies: RepositoryDependencies,
        httpClientDependencies: HttpClientDependencies
    ) {
        self.useCaseDependencies = useCaseDependencies
        self.repositoryDependencies = repositoryDependencies
        self.httpClientDependencies = httpClientDependencies
    }
}
