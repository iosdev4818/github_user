//
//  UserModelFixture.swift
//  DomainTests
//
//  Created by Bao Nguyen on 14/2/25.
//

@testable import Domain

struct UserModelFixture {
    static let user1 = UserModel(username: "user1", avatarURL: "https://example.com/avatar1.png", htmlURL: "https://github.com/user1", location: "London", follower: 200, following: 100)

    static let user2 = UserModel(username: "user2", avatarURL: "https://example.com/avatar2.png", htmlURL: "https://github.com/user2", location: "Paris", follower: 150, following: 75)
}
