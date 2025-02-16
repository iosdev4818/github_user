//
//  UserDaoTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import Testing
import CoreData
import Combine
@testable import Data

@Suite("UserDao", .serialized)
final class UserDaoTests: CoreDatabaseBaseTest {
    var sut: UserDao!

    override init() {
        super.init()
        sut = DefaultUserDao(coreDatabase: database)
    }

    // MARK: - upsertUsers
    @Test func testUpsertUsersWithoutExistingLocalUser() throws {
        try testUpsertUsers(
            existingUsers: [],
            usersToUpsert: [
                Network.UserFixture.user1,
                Network.UserFixture.user2
            ],
            expectedUsers: [
                UserFixture.user1(),
                UserFixture.user2(),
            ]
        )
    }

    @Test func testUpsertUsersWithExistingLocalUser() throws {
        try testUpsertUsers(
            existingUsers: [
                UserFixture.user1(in: currentBackgroundContext),
                UserFixture.user2(in: currentBackgroundContext)
            ],
            usersToUpsert: [
                Network.UserFixture.user1
            ],
            expectedUsers: [
                UserFixture.user1(),
                UserFixture.user2(),
                UserFixture.user1()
            ])
    }

    // MARK: - upsertUserDetail
    @Test func testUpsertUserDetailWithoutExisingLocalUser() throws {
        try testUpsertUserDetail(
            existingUsers: [],
            userToUpsert: Network.UserDetailFixture.user1,
            expectedUsers: [
                UserFixture.user1Detail()
            ]
        )
    }

    @Test func testUpsertUserDetailWithExisingLocalUser() throws {
        try testUpsertUserDetail(
            existingUsers: [
                UserFixture.user1(in: currentBackgroundContext),
                UserFixture.user2(in: currentBackgroundContext)
            ],
            userToUpsert: Network.UserDetailFixture.user1,
            expectedUsers: [
                UserFixture.user1Detail(),
                UserFixture.user2()
            ]
        )
    }

    // MARK: - getUsers
    @Test func testGetUsers() async throws {
        let expectedUsers = [
            UserFixture.user1(in: viewContext),
            UserFixture.user2(in: viewContext)
        ]
        try persistentContainer.saveContext(of: expectedUsers)

        await confirmation("Get users from Core Data") { confirmation in
            _ = sut.getUsers(in: viewContext)
                .sink { actualUsers in
                    #expect(actualUsers.count == 2)
                    zip(actualUsers, expectedUsers).forEach {
                        #expect(User.assertEqual($0, $1))
                    }

                    confirmation()
                }
        }
    }

    // MARK: - getUserDetail
    @Test func testGetUserDetailWithoutExistingUser() async throws {
        await confirmation("Get user detail from Core Data") { confirmation in
            _ = sut.getUserDetail(by: "aaa", in: viewContext)
                .sink { actualUser in
                    #expect(actualUser == nil)

                    confirmation()
                }
        }
    }

    @Test func testGetUserDetailWithExistingUser() async throws {
        try persistentContainer.saveContext(of: [
            UserFixture.user1(in: viewContext),
            UserFixture.user2(in: viewContext)
        ])

        await confirmation("Get user detail from Core Data") { confirmation in
            _ = sut.getUserDetail(by: "mojombo", in: viewContext)
                .sink { actualUser in
                    #expect(actualUser != nil)
                    #expect(User.assertEqual(actualUser!, UserFixture.user1()))

                    confirmation()
                }
        }
    }

    // MARK: - getUsersCount
    @Test func testGetUsersCountWithoutExistingUser() async throws {
        let count = try sut.getUsersCount(in: viewContext)

        #expect(count == 0)
    }

    @Test func testGetUsersCountWithExistingUser() async throws {
        try persistentContainer.saveContext(of: [
            UserFixture.user1(in: viewContext),
            UserFixture.user2(in: viewContext)
        ])

        let count = try sut.getUsersCount(in: viewContext)

        #expect(count == 2)
    }

    // MARK: - clearUsers
    @Test func testClearUserWithoutExsingUser() throws {
        try sut.clearUsers(in: currentBackgroundContext)

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.sortDescriptors = User.sortDescriptors()
        let actualUsers = (try? currentBackgroundContext.fetch(fetchRequest)) ?? []

        #expect(actualUsers.isEmpty)
    }

    @Test func testClearUserWithExsingUser() throws {
        try persistentContainer.saveContext(of: [
            UserFixture.user1(in: viewContext),
            UserFixture.user2(in: viewContext),
        ])

        try sut.clearUsers(in: currentBackgroundContext)

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.sortDescriptors = User.sortDescriptors()
        let actualUsers = (try? currentBackgroundContext.fetch(fetchRequest)) ?? []

        #expect(actualUsers.isEmpty)
    }
}

private extension UserDaoTests {
    func testUpsertUsers(
        existingUsers: [User],
        usersToUpsert: [Network.User],
        expectedUsers: [User]) throws {
            try persistentContainer.saveContext(of: existingUsers)

            try sut.upsertUsers(users: usersToUpsert, in: currentBackgroundContext)

            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.sortDescriptors = User.sortDescriptors()

            let actualUsers = (try? currentBackgroundContext.fetch(fetchRequest)) ?? []

            #expect(actualUsers.count == expectedUsers.count)
            for (actualUser, expectedUser) in zip(actualUsers, expectedUsers) {
                #expect(User.assertEqual(actualUser, expectedUser))
            }
        }

    func testUpsertUserDetail(
        existingUsers: [User],
        userToUpsert: Network.UserDetail,
        expectedUsers: [User]) throws {
            try persistentContainer.saveContext(of: existingUsers)

            try sut.upsertUserDetail(userDetail: userToUpsert, in: currentBackgroundContext)

            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.sortDescriptors = User.sortDescriptors()

            let actualUsers = (try? currentBackgroundContext.fetch(fetchRequest)) ?? []

            #expect(actualUsers.count == expectedUsers.count)
            for (actualUser, expecedUser) in zip(actualUsers, expectedUsers) {
                #expect(User.assertEqual(actualUser, expecedUser))
            }
        }
}
