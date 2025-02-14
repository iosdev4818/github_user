//
//  UserDetailViewModelTests.swift
//  GithubUserTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import XCTest
import Combine
@testable import GithubUser
@testable import Domain

final class UserDetailViewModelTests: XCTestCase {
    var sut: UserDetailViewModel!
    var loadUserDetail: LoadUserDetailUseCaseSpy!
    var getUserDetail: GetUserDetailUseCaseSpy!

    override func setUpWithError() throws {
        try super.setUpWithError()
        loadUserDetail = LoadUserDetailUseCaseSpy()
        getUserDetail = GetUserDetailUseCaseSpy()

    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        loadUserDetail = nil
        getUserDetail = nil
        sut = nil
    }

    func testInit() async {
        let expectation = self.expectation(description: "Load user detail")
        loadUserDetail.invokeClosure = { _ in
            expectation.fulfill()
        }

        sut = UserDetailViewModel(username: "", loadUserDetail: loadUserDetail, getUserDetail: getUserDetail)

        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertTrue(loadUserDetail.invokeCalled)
    }

    func testStartUpdating() async throws {
        let expectedUser = UserModelFixture.user1

        getUserDetail.invokeUsernameClosure = { username in
            XCTAssertEqual(username, "username")
            return Just(expectedUser)
                .eraseToAnyPublisher()
        }

        sut = UserDetailViewModel(username: "username", loadUserDetail: loadUserDetail, getUserDetail: getUserDetail)
        sut.startUpdating()

        XCTAssertTrue(getUserDetail.invokeUsernameCalled)

        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        XCTAssertEqual(sut.user, expectedUser)
    }

    func testStopUpdating() async throws {
        let expectedUser = UserModelFixture.user1

        getUserDetail.invokeUsernameClosure = { username in
            XCTAssertEqual(username, "username")
            return Just(expectedUser)
                .eraseToAnyPublisher()
        }

        sut = UserDetailViewModel(username: "username", loadUserDetail: loadUserDetail, getUserDetail: getUserDetail)
        sut.startUpdating()

        XCTAssertTrue(getUserDetail.invokeUsernameCalled)

        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        XCTAssertEqual(sut.user, expectedUser)

        sut.stopUpdating()

        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        XCTAssertEqual(sut.user, expectedUser)
    }

}
