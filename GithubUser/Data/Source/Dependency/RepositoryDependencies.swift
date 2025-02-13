//
//  RepositoryDependencies.swift
//  Data
//
//  Created by Bao Nguyen on 12/2/25.
//

public protocol RepositoryDependencies {
    var githubRepository: GithubRepository { get }
}

final class DefaultRepositoryDependencies: RepositoryDependencies {
    private let remoteDataSourceDependencies: RemoteDataSourceDependencies

    init(
        remoteDataSourceDependencies: RemoteDataSourceDependencies
    ) {
        self.remoteDataSourceDependencies = remoteDataSourceDependencies
    }

    lazy var githubRepository: GithubRepository = {
        DefaultGithubRepository(githubRemoteDataSource: remoteDataSourceDependencies.githubRemoteDataSource)
    }()
}

public final class RepositoryDependenciesFactory {
    public static func make(httpClientDependencies: HttpClientDependencies) -> RepositoryDependencies {
        DefaultRepositoryDependencies(
            remoteDataSourceDependencies: DefaultRemoteDataSourceDependencies(
                httpClientDependencies: httpClientDependencies
            )
        )
    }
}
