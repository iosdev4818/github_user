//
//  GithubRepositoryTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 13/2/25.
//

import XCTest
@testable import Data

final class GithubRepositoryTests: CoreDatabaseBaseTest {
    // MARK: - loadUser
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
        
    }
}
