//
//  User+Extension.swift
//  Data
//
//  Created by Bao Nguyen on 13/2/25.
//

import Domain
import CoreData

// MARK: - Sort Descriptor
extension User {
    static func sortDescriptors() -> [NSSortDescriptor] {
        [
            NSSortDescriptor(keyPath: \User.timestamp, ascending: true),
        ]
    }
}

// MARK: - Predicate
extension User {
    static func predicateForUsername(_ username: String) -> NSPredicate {
        NSPredicate(format: "username == %@", username)
    }
}

// MARK: - Helpers
extension User {
    func toUserModel() -> UserModel? {
        guard let context = self.managedObjectContext else {
            return nil
        }
        // For thread-safe
        return context.performAndWait {
            UserModel(
                username: username ?? "",
                avatarURL: avatar ?? "",
                htmlURL: htmlUrlString ?? "",
                location: location ?? "",
                follower: Int(followers),
                following: Int(following)
            )
        }
    }
}
