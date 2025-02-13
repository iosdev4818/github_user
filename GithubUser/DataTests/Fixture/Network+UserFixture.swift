//
//  Network+UserFixture.swift
//  DataTests
//
//  Created by Bao Nguyen on 13/2/25.
//

@testable import Data

extension Network {
    struct UserFixture {
        static let user1: Network.User = user(id: 1, login: "mojombo", avatar: "https://avatars.githubusercontent.com/u/1?v=4", html: "https://github.com/mojombo")

        static let user2: Network.User = user(id: 2, login: "defunkt", avatar: "https://avatars.githubusercontent.com/u/2?v=4", html:  "https://github.com/defunkt")

        static let user1JSON = """
    {
        "id": 1,
        "login": "mojombo",
        "avatar_url": "https://avatars.githubusercontent.com/u/1?v=4",
        "html_url": "https://github.com/mojombo"
    }
    """

        static let user1InvalidJSON = """
        {
            "id": "one", 
            "login": "mojombo",
            "avatar_url": "https://avatars.githubusercontent.com/u/1?v=4",
            "html_url": "https://github.com/mojombo"
        }
        """ // 'id' should be an Int, not a String
    }
}

private extension Network.UserFixture {
    static func user(
        id: Int,
        login: String,
        avatar: String,
        html: String) -> Network.User {
        Network.User(
            id: id,
            login: login,
            avatar_url: avatar,
            html_url: html
        )
    }
}
