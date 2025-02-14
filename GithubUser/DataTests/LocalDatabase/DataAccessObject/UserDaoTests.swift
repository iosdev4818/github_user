//
//  UserDaoTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import XCTest
import CoreData
@testable import Data

final class UserDaoTests: CoreDatabaseBaseTest {

    var sut: UserDao!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DefaultUserDao(coreDatabase: database)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    // MARK: - upsertUsers
    func testUpsertUsersWithoutExistingLocalUser() throws {
        try testUpsertUsers(
            existingUsers: [],
            usersToUpsert: [
                Network.UserFixture.user1,
                Network.UserFixture.user2
            ],
            expectedUsers: 2)
    }

    func testUpsertUsersWithExistingLocalUser() throws {
        try testUpsertUsers(
            existingUsers: [
                UserFixture.user1(in: currentBackgroundContext),
                UserFixture.user2(in: currentBackgroundContext)
            ],
            usersToUpsert: [
                Network.UserFixture.user1
            ],
            expectedUsers: 3)
    }

    // MARK: - upsertUserDetail
    func testUpsertUserDetailWithoutExisingLocalUser() throws {
        try testUpsertUserDetail(
            existingUsers: [],
            userToUpsert: Network.UserDetailFixture.user1,
            expectedUsers: 1)
    }

    func testUpsertUserDetailWithExisingLocalUser() throws {
        try testUpsertUserDetail(
            existingUsers: [
                UserFixture.user1(in: currentBackgroundContext),
                UserFixture.user2(in: currentBackgroundContext)
            ],
            userToUpsert: Network.UserDetailFixture.user1,
            expectedUsers: 2)
    }

    // MARK: - getUsers
    func testGetUsers() async throws {
        try persistentContainer.saveContext(of: [
            UserFixture.user1(in: currentBackgroundContext),
            UserFixture.user2(in: currentBackgroundContext)
        ])

        let expectation = self.expectation(description: "Get users from Core Data")

        let cancelable = sut.getUsers(in: viewContext)
            .sink { actualUsers in
                XCTAssertEqual(actualUsers.count, 2)
                expectation.fulfill()
            }

        await fulfillment(of: [expectation], timeout: 1.0)
        cancelable.cancel()
    }

    // MARK: - getUserDetail
    func testGetUserDetailWithoutExistingUser() async throws {
        let expectation = self.expectation(description: "Get user detail from Core Data")

        let cancelable = sut.getUserDetail(by: "aaa", in: viewContext)
            .sink { actualUser in
                XCTAssertNil(actualUser)
                expectation.fulfill()
            }

        await fulfillment(of: [expectation], timeout: 1.0)
        cancelable.cancel()
    }

    func testGetUserDetaulWithExistingUser() async throws {
        try persistentContainer.saveContext(of: [
            UserFixture.user1(in: currentBackgroundContext),
            UserFixture.user2(in: currentBackgroundContext)
        ])

        let expectation = self.expectation(description: "Get user detail from Core Data")

        let cancelable = sut.getUserDetail(by: "mojombo", in: viewContext)
            .sink { actualUser in
                XCTAssertNotNil(actualUser)
                expectation.fulfill()
            }

        await fulfillment(of: [expectation], timeout: 1.0)
        cancelable.cancel()
    }

    // MARK: - getUsersCount
    func testGetUsersCount() async throws {
        try persistentContainer.saveContext(of: [
            UserFixture.user1(in: currentBackgroundContext),
            UserFixture.user2(in: currentBackgroundContext)
        ])

        let count = try sut.getUsersCount(in: viewContext)

        XCTAssertEqual(count, 2)
    }
}

private extension UserDaoTests {
    func testUpsertUsers(
        existingUsers: [User],
        usersToUpsert: [Network.User],
        expectedUsers: Int) throws {
            try persistentContainer.saveContext(of: existingUsers)

            try sut.upsertUsers(users: usersToUpsert, in: currentBackgroundContext)

            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: #keyPath(User.timestamp), ascending: false),
            ]
            let actualUsers = (try? currentBackgroundContext.fetch(fetchRequest)) ?? []
            XCTAssertEqual(actualUsers.count, expectedUsers)
        }

    func testUpsertUserDetail(
        existingUsers: [User],
        userToUpsert: Network.UserDetail,
        expectedUsers: Int) throws {
            try persistentContainer.saveContext(of: existingUsers)

            try sut.upsertUserDetail(userDetail: userToUpsert, in: currentBackgroundContext)

            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: #keyPath(User.timestamp), ascending: false),
            ]
            let actualUsers = (try? currentBackgroundContext.fetch(fetchRequest)) ?? []
            XCTAssertEqual(actualUsers.count, expectedUsers)
        }
}
