//
//  UserTranslator.swift
//  Data
//
//  Created by Bao Nguyen on 13/2/25.
//

import Domain
import CoreData
internal import Spyable

@Spyable(behindPreprocessorFlag: "DEBUG || TESTING")
protocol UserTranslator {
    /// Convert `User` entity to `UserModel`
    /// - Parameter user: `User` entity
    /// - Returns: `UserModel`
    func invoke(user: User?) -> UserModel?

    /// Convert list of `User` entity to list of `UserModel`
    /// - Parameter users: List of `User` entity
    /// - Returns: List of `UserModel`
    func invoke(users: [User]) -> [UserModel]
}

struct DefaultUserTranslator: UserTranslator {
    func invoke(user: User?) -> UserModel? {
        user?.toUserModel()
    }

    func invoke(users: [User]) -> [UserModel] {
        var results = [UserModel]()
        for user in users {
            if let userModel = user.toUserModel() {
                results.append(userModel)
            }
        }
        return results
    }
}
