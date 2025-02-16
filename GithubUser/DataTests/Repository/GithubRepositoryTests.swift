//
//  GithubRepositoryTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 13/2/25.
//

import Testing
import Combine
@testable import Data

@Suite("GithubRepositoryTests", .serialized)
final class GithubRepositoryTests: CoreDatabaseBaseTest {
    @Test func testLoadUser() async throws {
        let expectedUsers = [
            Network.UserFixture.user1,
            Network.UserFixture.user2
        ]

        let remoteDatasource = GithubRemoteDataSourceSpy()
        remoteDatasource.loadUsersLimitOffsetClosure = { limit, offset in
            #expect(limit == 20)
            #expect(offset == 20)

            return expectedUsers
        }

        let userDao = UserDaoSpy()
        userDao.upsertUsersUsersInClosure = { actualUsers, _ in
            #expect(actualUsers == expectedUsers)
        }

        let sut = DefaultGithubRepository(
            githubRemoteDataSource: remoteDatasource,
            userDao: userDao,
            dataBase: database,
            userTranslator: UserTranslatorSpy()
        )

        try await sut.loadUsers(limit: 20, offset: 20)
    }

    @Test func testLoadUserDetail() async throws {
        let remoteDatasource = GithubRemoteDataSourceSpy()
        remoteDatasource.loadUserDetailUsernameClosure = { username in
            #expect(username == "username")
            return Network.UserDetailFixture.user1
        }

        let userDao = UserDaoSpy()
        userDao.upsertUserDetailUserDetailInClosure = { actualUserDetail, _ in
            #expect(actualUserDetail == Network.UserDetailFixture.user1)
        }
        let sut = DefaultGithubRepository(
            githubRemoteDataSource: remoteDatasource,
            userDao: userDao,
            dataBase: database,
            userTranslator: UserTranslatorSpy()
        )

        try await sut.loadUserDetail(username: "username")
    }

    @Test func testGetUsers() async throws {
        let userDao = UserDaoSpy()
        userDao.getUsersInClosure = { _ in
            return Just([])
            .eraseToAnyPublisher()
        }

        let translator = UserTranslatorSpy()
        translator.invokeUsersClosure = { _ in
            return []
        }

        let sut = DefaultGithubRepository(
            githubRemoteDataSource: GithubRemoteDataSourceSpy(),
            userDao: userDao,
            dataBase: database,
            userTranslator: translator
        )

        await confirmation("get users") { confirmation in
            _ = sut
                .getUsers()
                .sink { actualUsers in
                    #expect(actualUsers.isEmpty)

                    confirmation()
                }
        }
    }

    @Test func testGetUserDetail() async throws {
        let userDao = UserDaoSpy()
        userDao.getUserDetailByInClosure = { username, _ in
            #expect(username == "username")
            return Just(nil)
                .eraseToAnyPublisher()
        }

        let translator = UserTranslatorSpy()
        translator.invokeUserClosure = { _ in
            return nil
        }

        let sut = DefaultGithubRepository(
            githubRemoteDataSource: GithubRemoteDataSourceSpy(),
            userDao: userDao,
            dataBase: database,
            userTranslator: translator
        )

        await confirmation("get user detail") { confirmation in
            _ = sut
                .getUserDetail(username: "username")
                .sink { actualUser in
                    #expect(actualUser == nil)

                    confirmation()
                }
        }
    }

    @Test func testGetUsersCount() async {
        let userDao = UserDaoSpy()
        userDao.getUsersCountInClosure = { _ in
            return 10
        }

        let sut = DefaultGithubRepository(
            githubRemoteDataSource: GithubRemoteDataSourceSpy(),
            userDao: userDao,
            dataBase: database,
            userTranslator: UserTranslatorSpy()
        )

        let actual = sut.getUsersCount()

        #expect(actual == 10)
    }
}
