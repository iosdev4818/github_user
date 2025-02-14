//
//  UserTranslator.swift
//  Data
//
//  Created by Bao Nguyen on 13/2/25.
//

import Domain
import CoreData
internal import Spyable

enum TranslatorError: Error {
    case noManagedObjectContext
}

@Spyable(behindPreprocessorFlag: "DEBUG || TESTING", accessLevel: .public)
protocol UserTranslator {
    func invoke(user: User?) -> UserModel?
    func invoke(users: [User]) -> [UserModel]
}

struct DefaultUserTranslator: UserTranslator {
    func invoke(user: User?) -> UserModel? {
        user?.toUserModel()
    }

    func invoke(users: [User]) -> [UserModel] {
        users.compactMap {
            $0.toUserModel()
        }
    }
}
