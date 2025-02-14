//
//  UserTranslator.swift
//  Data
//
//  Created by Bao Nguyen on 13/2/25.
//

import Domain
import CoreData

enum TranslatorError: Error {
    case noManagedObjectContext
}

protocol UserTranslator {
    func invoke(_ user: User?) -> UserModel?
    func invoke(_ users: [User]) -> [UserModel]
}

struct DefaultUserTranslator: UserTranslator {
    func invoke(_ user: User?) -> UserModel? {
        user?.toUserModel()
    }

    func invoke(_ users: [User]) -> [UserModel] {
        users.compactMap {
            $0.toUserModel()
        }
    }
}
