//
//  UserModel.swift
//  Domain
//
//  Created by Bao Nguyen on 13/2/25.
//

public struct UserModel: Identifiable, Hashable {
    public let id = UUID().uuidString
    public let username: String
    public let avatarURL: String
    public let htmlURL: String
    public let location: String
    public let follower: Int
    public let following: Int

    public init(username: String, avatarURL: String, htmlURL: String, location: String, follower: Int, following: Int) {
        self.username = username
        self.avatarURL = avatarURL
        self.htmlURL = htmlURL
        self.location = location
        self.follower = follower
        self.following = following
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(username)
        hasher.combine(avatarURL)
        hasher.combine(htmlURL)
        hasher.combine(location)
        hasher.combine(follower)
        hasher.combine(following)
    }
}
