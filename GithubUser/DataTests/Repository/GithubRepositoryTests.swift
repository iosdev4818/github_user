//
//  GithubRepositoryTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 13/2/25.
//

import XCTest
import Combine
@testable import Data

final class GithubRepositoryTests: CoreDatabaseBaseTest {
    func testLoadUser() async throws {
        let expectedUsers = [
            Network.UserFixture.user1,
            Network.UserFixture.user2
        ]

        let remoteDatasourceExpectation = self.expectation(description: "Remote Datasource")
        let remoteDatasource = GithubRemoteDataSourceSpy()
        remoteDatasource.loadUsersLimitOffsetClosure = { limit, offset in
            XCTAssertEqual(limit, 20)
            XCTAssertEqual(offset, 20)
            remoteDatasourceExpectation.fulfill()
            return expectedUsers
        }

        let userDaoExpectation = self.expectation(description: "User Dao")
        let userDao = UserDaoSpy()
        userDao.upsertUsersUsersInClosure = { actualUsers, _ in
            XCTAssertEqual(actualUsers, expectedUsers)
            userDaoExpectation.fulfill()
        }

        let sut = DefaultGithubRepository(
            githubRemoteDataSource: remoteDatasource,
            userDao: userDao,
            dataBase: database,
            userTranslator: UserTranslatorSpy()
        )

        try await sut.loadUsers(limit: 20, offset: 20)

        await fulfillment(of: [remoteDatasourceExpectation, userDaoExpectation], timeout: 1.0)
    }

    func testLoadUserDetail() async throws {
        let remoteDatasourceExpectation = self.expectation(description: "Remote Datasource")
        let remoteDatasource = GithubRemoteDataSourceSpy()
        remoteDatasource.loadUserDetailUsernameClosure = { username in
            XCTAssertEqual(username, "username")
            remoteDatasourceExpectation.fulfill()
            return Network.UserDetailFixture.user1
        }

        let userDaoExpectation = self.expectation(description: "User Dao")
        let userDao = UserDaoSpy()
        userDao.upsertUserDetailUserDetailInClosure = { actualUserDetail, _ in
            XCTAssertEqual(actualUserDetail, Network.UserDetailFixture.user1)
            userDaoExpectation.fulfill()
        }
        let sut = DefaultGithubRepository(
            githubRemoteDataSource: remoteDatasource,
            userDao: userDao,
            dataBase: database,
            userTranslator: UserTranslatorSpy()
        )

        try await sut.loadUserDetail(username: "username")

        await fulfillment(of: [remoteDatasourceExpectation, userDaoExpectation], timeout: 1.0)
    }

    func testGetUsers() async throws {
        let userDaoExpectation = self.expectation(description: "User Dao")
        let userDao = UserDaoSpy()
        userDao.getUsersInClosure = { _ in
            userDaoExpectation.fulfill()
            return Just([])
            .eraseToAnyPublisher()
        }

        let translatorExpectation = self.expectation(description: "User Translator")
        let translator = UserTranslatorSpy()
        translator.invokeUsersClosure = { _ in
            translatorExpectation.fulfill()
            return []
        }

        let sut = DefaultGithubRepository(
            githubRemoteDataSource: GithubRemoteDataSourceSpy(),
            userDao: userDao,
            dataBase: database,
            userTranslator: translator
        )

        let cancelable = sut
            .getUsers()
            .sink { actualUsers in
                XCTAssertTrue(actualUsers.isEmpty)
            }

        await fulfillment(of: [userDaoExpectation, translatorExpectation], timeout: 1.0)
        cancelable.cancel()
    }

    func testGetUserDetail() async throws {
        let userDaoExpectation = self.expectation(description: "User Dao")
        let userDao = UserDaoSpy()
        userDao.getUserDetailByInClosure = { username, _ in
            XCTAssertEqual(username, "username")
            userDaoExpectation.fulfill()
            return Just(nil)
                .eraseToAnyPublisher()
        }

        let translatorExpectation = self.expectation(description: "User Translator")
        let translator = UserTranslatorSpy()
        translator.invokeUserClosure = { _ in
            translatorExpectation.fulfill()
            return nil
        }

        let sut = DefaultGithubRepository(
            githubRemoteDataSource: GithubRemoteDataSourceSpy(),
            userDao: userDao,
            dataBase: database,
            userTranslator: translator
        )

        let cancelable = sut
            .getUserDetail(username: "username")
            .sink { actualUser in
                XCTAssertNil(actualUser)
            }

        await fulfillment(of: [userDaoExpectation, translatorExpectation], timeout: 1.0)
        cancelable.cancel()
    }

    func testGetUsersCount() async {
        let userDaoExpectation = self.expectation(description: "User Dao")
        let userDao = UserDaoSpy()
        userDao.getUsersCountInClosure = { _ in
            userDaoExpectation.fulfill()
            return 10
        }

        let sut = DefaultGithubRepository(
            githubRemoteDataSource: GithubRemoteDataSourceSpy(),
            userDao: userDao,
            dataBase: database,
            userTranslator: UserTranslatorSpy()
        )

        let actual = sut.getUsersCount()

        await fulfillment(of: [userDaoExpectation], timeout: 1.0)

        XCTAssertEqual(actual, 10)
    }
}
