//
//  Network+UserDetailFixture.swift
//  DataTests
//
//  Created by Bao Nguyen on 13/2/25.
//

@testable import Data

extension Network {
    struct UserDetailFixture {
        static let user1 = Network.UserDetail(
            id: 1,
            login: "mojombo",
            avatar_url: "https://avatars.githubusercontent.com/u/1?v=4",
            html_url: "https://github.com/mojombo",
            location: "San Francisco",
            followers: 24127,
            following: 11
        )

        static let user1JSON = """
    {
        "id": 1,
        "login": "mojombo",
        "avatar_url": "https://avatars.githubusercontent.com/u/1?v=4",
        "html_url": "https://github.com/mojombo",
        "location": "San Francisco",
        "followers": 24127,
        "following": 11
    }
    """

        static let user1IncompleteJSON = """
        {
            "id": 1,
            "login": "mojombo",
            "avatar_url": "https://avatars.githubusercontent.com/u/1?v=4",
            "html_url": "https://github.com/mojombo",
        }
        """ // Missing "location", "followers", and "following"

        static let user1InvalidJSON = """
        {
            "id": "one", // 'id' should be an Int, not a String
            "login": "mojombo",
            "avatar_url": "https://avatars.githubusercontent.com/u/1?v=4",
            "html_url": "https://github.com/mojombo",
            "location": "San Francisco",
            "followers": 24127,
            "following": 11
        }
        """
    }
}
