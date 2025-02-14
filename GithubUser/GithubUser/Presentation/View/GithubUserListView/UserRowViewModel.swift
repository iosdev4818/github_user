//
//  UserRowViewModel.swift
//  GithubUser
//
//  Created by Bao Nguyen on 13/2/25.
//

import SwiftUI
import Domain

struct UserRowViewModel {
    private let user: UserModel

    init(user: UserModel) {
        self.user = user
    }

    var avatarURL: String {
        user.avatarURL
    }

    var displayName: String {
        user.username
    }

    var htmlURL: String {
        user.htmlURL
    }
}
