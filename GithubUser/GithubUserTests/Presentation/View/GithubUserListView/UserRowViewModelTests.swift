//
//  UserRowViewModelTests.swift
//  GithubUserTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import XCTest
@testable import GithubUser
@testable import Domain

final class UserRowViewModelTests: XCTestCase {

    func test() {
        let sut = UserRowViewModel(user: UserModelFixture.user1)
        XCTAssertEqual(sut.avatarURL, UserModelFixture.user1.avatarURL)
        XCTAssertEqual(sut.displayName, UserModelFixture.user1.username)
        XCTAssertEqual(sut.htmlURL, UserModelFixture.user1.htmlURL)
    }

}
