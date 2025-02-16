//
//  UserFixture.swift
//  DataTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import CoreData
@testable import Data

struct UserFixture {
    static func user1(in context: NSManagedObjectContext? = nil) -> User {
        user(
            username: "mojombo",
            avatar: "https://avatars.githubusercontent.com/u/1?v=4",
            html: "https://github.com/mojombo",
            location: "",
            followers: 0,
            following: 0,
            in: context
        )
    }

    static func user1Detail(in context: NSManagedObjectContext? = nil) -> User {
        user(
            username: "mojombo",
            avatar: "https://avatars.githubusercontent.com/u/1?v=4",
            html: "https://github.com/mojombo",
            location: "San Francisco",
            followers: 24127,
            following: 11,
            in: context
        )
    }

    static func user2(in context: NSManagedObjectContext? = nil) -> User {
        user(
            username: "defunkt",
            avatar: "https://avatars.githubusercontent.com/u/2?v=4",
            html: "https://github.com/defunkt",
            location: "",
            followers: 0,
            following: 0,
            in: context
        )
    }
}

private extension UserFixture {
    static func user(username: String, avatar: String, html: String, location: String, followers: Int, following: Int, in context: NSManagedObjectContext? = nil) -> User {
        let user = User.instance(in: context)
        user.timestamp = Date()
        user.username = username
        user.avatar = avatar
        user.htmlUrlString = html
        user.location = location
        user.followers = Int32(followers)
        user.following = Int32(following)
        return user
    }
}
