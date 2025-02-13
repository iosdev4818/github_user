//
//  RemoteDataSourceDependencies.swift
//  APINetwork
//
//  Created by Bao Nguyen on 12/2/25.
//

protocol RemoteDataSourceDependencies {
    var githubRemoteDataSource: GithubRemoteDataSource { get }
}

final class DefaultRemoteDataSourceDependencies: RemoteDataSourceDependencies {
    private let httpClientDependencies: HttpClientDependencies

    init(
        httpClientDependencies: HttpClientDependencies
    ) {
        self.httpClientDependencies = httpClientDependencies
    }

    lazy var githubRemoteDataSource: GithubRemoteDataSource = {
        DefaultGithubRemoteDataSource(httpClient: httpClientDependencies.httpClient)
    }()
}
