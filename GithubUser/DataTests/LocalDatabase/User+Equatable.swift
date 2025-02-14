//
//  User+Equable.swift
//  DataTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import CoreData
@testable import Data

extension User {
    public static func assertEqual(_ lhs: User, _ rhs: User) -> Bool {
        return lhs.avatar == rhs.avatar &&
        lhs.followers == rhs.followers &&
        lhs.following == rhs.following &&
        lhs.htmlUrlString == rhs.htmlUrlString &&
        lhs.location == rhs.location &&
        lhs.username == rhs.username
    }
}
