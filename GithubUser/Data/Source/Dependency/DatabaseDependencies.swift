//
//  DatabaseDependencies.swift
//  Data
//
//  Created by Bao Nguyen on 13/2/25.
//

protocol DatabaseDependencies {
    var coreDatabase: CoreDatabase { get }

    var userDao: UserDao { get }
}

final class DefaultDatabaseDependencies: DatabaseDependencies {

    lazy var coreDatabase: CoreDatabase = {
        DefaultCoreDatabase()
    }()

    lazy var userDao: UserDao = {
        DefaultUserDao(coreDatabase: coreDatabase)
    }()
}
