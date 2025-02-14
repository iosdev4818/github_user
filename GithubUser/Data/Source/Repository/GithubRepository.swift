//
//  GithubRepository.swift
//  Data
//
//  Created by Bao Nguyen on 12/2/25.
//
import Domain
import CoreData
import Combine
internal import Spyable

struct DefaultGithubRepository: GithubRepository {
    private let githubRemoteDataSource: GithubRemoteDataSource
    private let userDao: UserDao
    private let dataBase: CoreDatabase
    private let userTranslator: UserTranslator

    init(
        githubRemoteDataSource: GithubRemoteDataSource,
        userDao: UserDao,
        dataBase: CoreDatabase,
        userTranslator: UserTranslator
    ) {
        self.githubRemoteDataSource = githubRemoteDataSource
        self.userDao = userDao
        self.dataBase = dataBase
        self.userTranslator = userTranslator
    }

    func loadUsers(limit: Int, offset: Int) async throws {
        // Fetch List User from remote first
        let users = try await githubRemoteDataSource.loadUsers(limit: limit, offset: offset)
        // Then upsert it into Database in background context
        try userDao.upsertUsers(users: users, in: dataBase.currentBackgroundContext)
    }

    func loadUserDetail(username: String) async throws {
        // Fetch User detail from remote
        let userDetail = try await githubRemoteDataSource.loadUserDetail(username: username)
        // Then upsert it into Database in background context
        try userDao.upsertUserDetail(userDetail: userDetail, in: dataBase.currentBackgroundContext)
    }

    func getUsers() -> AnyPublisher<[UserModel], Never> {
        userDao.getUsers(in: dataBase.viewContext)
            .map {
                userTranslator.invoke(users: $0)
            }
            .eraseToAnyPublisher()
    }

    func getUserDetail(username: String) -> AnyPublisher<UserModel?, Never> {
        userDao.getUserDetail(by: username, in: dataBase.viewContext)
            .map {
                userTranslator.invoke(user: $0)
            }
            .eraseToAnyPublisher()
    }

    func getUsersCount() -> Int {
        do {
            return try userDao.getUsersCount(in: dataBase.currentBackgroundContext)
        } catch {
            return 0
        }
    }
}
