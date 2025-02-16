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

    /// Load List of User from remote API
    /// Then insert it into Database
    /// - Parameters:
    ///   - limit: item per page
    ///   - offset: start index
    func loadUsers(limit: Int, offset: Int) async throws {
        // Fetch List User from remote first
        let users = try await githubRemoteDataSource.loadUsers(limit: limit, offset: offset)
        // Then upsert it into Database in background context
        try userDao.upsertUsers(users: users, in: dataBase.currentBackgroundContext)
    }

    /// Load User detail from remote API
    /// Then insert it into Database
    /// - Parameter username: username of user
    func loadUserDetail(username: String) async throws {
        // Fetch User detail from remote
        let userDetail = try await githubRemoteDataSource.loadUserDetail(username: username)
        // Then upsert it into Database in background context
        try userDao.upsertUserDetail(userDetail: userDetail, in: dataBase.currentBackgroundContext)
    }

    /// Get and Observe User from CoreData
    /// - Returns: AnyPublisher<UserModel>
    func getUsers() -> AnyPublisher<[UserModel], Never> {
        userDao.getUsers(in: dataBase.viewContext)
            .map {
                userTranslator.invoke(users: $0)
            }
            .eraseToAnyPublisher()
    }

    /// Get and Observe User from CoreData
    /// - Parameter username: username of user
    /// - Returns: AnyPublisher<UserModel?>
    func getUserDetail(username: String) -> AnyPublisher<UserModel?, Never> {
        userDao.getUserDetail(by: username, in: dataBase.viewContext)
            .map {
                userTranslator.invoke(user: $0)
            }
            .eraseToAnyPublisher()
    }

    /// Get total of user in CoreData
    /// - Returns: Total user
    func getUsersCount() -> Int {
        do {
            return try userDao.getUsersCount(in: dataBase.viewContext)
        } catch {
            return 0
        }
    }

    /// Delete all User in CoreData
    func deleteUsers() throws {
        try userDao.clearUsers(in: dataBase.currentBackgroundContext)
    }
}
