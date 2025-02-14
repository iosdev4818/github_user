//
//  RepositoryDependencies.swift
//  Data
//
//  Created by Bao Nguyen on 12/2/25.
//

import Domain

final class DefaultRepositoryDependencies: RepositoryDependencies {
    private let remoteDataSourceDependencies: RemoteDataSourceDependencies
    private let databaseDependencies: DatabaseDependencies
    private let translatorDependencies: TranslatorDependencies

    init(
        remoteDataSourceDependencies: RemoteDataSourceDependencies,
        databaseDependencies: DatabaseDependencies,
        translatorDependencies: TranslatorDependencies
    ) {
        self.remoteDataSourceDependencies = remoteDataSourceDependencies
        self.databaseDependencies = databaseDependencies
        self.translatorDependencies = translatorDependencies
    }

    lazy var githubRepository: GithubRepository = {
        DefaultGithubRepository(
            githubRemoteDataSource: remoteDataSourceDependencies.githubRemoteDataSource,
            userDao: databaseDependencies.userDao,
            dataBase: databaseDependencies.coreDatabase,
            userTranslator: translatorDependencies.userTranslator
        )
    }()
}

public final class RepositoryDependenciesFactory {
    public static func make(httpClientDependencies: HttpClientDependencies) -> RepositoryDependencies {
        DefaultRepositoryDependencies(
            remoteDataSourceDependencies: DefaultRemoteDataSourceDependencies(
                httpClientDependencies: httpClientDependencies
            ),
            databaseDependencies: DefaultDatabaseDependencies(),
            translatorDependencies: DefaultTranslatorDependencies()
        )
    }
}
