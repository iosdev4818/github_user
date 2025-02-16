//
//  UserDao.swift
//  Data
//
//  Created by Bao Nguyen on 13/2/25.
//

import CoreData
import Combine
internal import Spyable

@Spyable(behindPreprocessorFlag: "DEBUG || TESTING")
protocol UserDao {
    func upsertUsers(users: [Network.User], in context: NSManagedObjectContext) throws
    func upsertUserDetail(userDetail: Network.UserDetail, in context: NSManagedObjectContext) throws
    func getUsers(in context: NSManagedObjectContext) -> AnyPublisher<[User], Never>
    func getUserDetail(by username: String, in context: NSManagedObjectContext) -> AnyPublisher<User?, Never>
    func getUsersCount(in context: NSManagedObjectContext) throws -> Int
}

struct DefaultUserDao: UserDao {

    struct Constant {
        static let defaultFetchBatchSize = 20
    }

    private let coreDatabase: CoreDatabase

    init(coreDatabase: CoreDatabase) {
        self.coreDatabase = coreDatabase
    }

    func upsertUsers(users: [Network.User], in context: NSManagedObjectContext) throws {
        for user in users {
            let userEntity = User(context: context)

            userEntity.timestamp = Date()
            userEntity.username = user.login
            userEntity.avatar = user.avatar_url
            userEntity.htmlUrlString = user.html_url
        }

        try context.saveChanges()
    }

    func upsertUserDetail(userDetail: Network.UserDetail, in context: NSManagedObjectContext) throws {
        var userEntities = [User]()

        let existingUsers = try getUser(by: userDetail.login, in: context)
        if !existingUsers.isEmpty {
            userEntities = existingUsers
        } else {
            let userEntity = User(context: context)
            userEntity.timestamp = Date()
            userEntities = [userEntity]
        }

        // Update properties
        for userEntity in userEntities {
            userEntity.username = userDetail.login
            userEntity.avatar = userDetail.avatar_url
            userEntity.htmlUrlString = userDetail.html_url
            userEntity.location = userDetail.location ?? ""
            userEntity.followers = Int32(userDetail.followers)
            userEntity.following = Int32(userDetail.following)
        }

        try context.saveChanges()
    }

    func getUsers(in context: NSManagedObjectContext) -> AnyPublisher<[User], Never> {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.fetchBatchSize = Constant.defaultFetchBatchSize
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = User.sortDescriptors()

        return FetchedResultsPublisher(fetchRequest: fetchRequest, in: context)
            .eraseToAnyPublisher()
    }

    func getUserDetail(by username: String, in context: NSManagedObjectContext) -> AnyPublisher<User?, Never> {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = User.predicateForUsername(username)
        fetchRequest.fetchBatchSize = Constant.defaultFetchBatchSize
        fetchRequest.fetchLimit = 1
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = User.sortDescriptors()

        return FetchedResultsPublisher(fetchRequest: fetchRequest, in: context)
            .map { users in
                var user: User?
                context.performAndWait {
                    user = users.first
                }
                return user
            }
            .eraseToAnyPublisher()
    }

    func getUsersCount(in context: NSManagedObjectContext) throws -> Int {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false

        return try context.performAndWait {
            try context.count(for: fetchRequest)
        }
    }
}

private extension DefaultUserDao {
    func getUser(by username: String, in context: NSManagedObjectContext) throws -> [User] {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = User.predicateForUsername(username)
        fetchRequest.returnsObjectsAsFaults = false

        return try context.performAndWait {
            try context.fetch(fetchRequest)
        }
    }
}
