//
//  GithubUserListViewModelTests.swift
//  GithubUserTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import XCTest
import Combine
@testable import GithubUser
@testable import Domain

final class GithubUserListViewModelTests: XCTestCase {
    var sut: GithubUserListViewModel!
    var loadUsers: LoadUsersUseCaseSpy!
    var getUsers: GetUsersUseCaseSpy!
    var coordinator: GithubUserListCoordinatorSpy!

    override func setUpWithError() throws {
        try super.setUpWithError()
        loadUsers = LoadUsersUseCaseSpy()
        loadUsers.shouldInvokeAtClosure = { _ in
            true
        }
        getUsers = GetUsersUseCaseSpy()
        coordinator = GithubUserListCoordinatorSpy()
        sut = GithubUserListViewModel(loadUsers: loadUsers, getUsers: getUsers, coordinator: coordinator)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        loadUsers = nil
        getUsers = nil
        coordinator = nil
        sut = nil
    }

    func testInit() {
        XCTAssertTrue(loadUsers.shouldInvokeAtCalled)
    }

    func testStartUpdating() async throws {
        let expectedUsers = [
            UserModelFixture.user1,
            UserModelFixture.user2
        ]

        getUsers.invokeClosure = {
            Just(expectedUsers)
            .eraseToAnyPublisher()
        }

        sut.startUpdating()

        XCTAssertTrue(getUsers.invokeCalled)

        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        XCTAssertEqual(sut.users, expectedUsers)
    }

    func testStopUpdating() async throws {
        let expectedUsers = [
            UserModelFixture.user1,
            UserModelFixture.user2
        ]

        getUsers.invokeClosure = {
            Just(expectedUsers)
                .eraseToAnyPublisher()
        }

        sut.startUpdating()

        XCTAssertTrue(getUsers.invokeCalled)

        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        XCTAssertEqual(sut.users, expectedUsers)

        sut.stopUpdating()

        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        XCTAssertEqual(sut.users, expectedUsers)
    }

    func testShouldShowLoadMoreViewWhenConditionsAreMetShouldReturnTrue() {
        sut.users = Array(repeating: UserModelFixture.user1, count: 20) // Exactly 1 full page (Constants.pageSize)

        XCTAssertTrue(sut.shouldShowLoadMoreView())
    }

    func testShouldShowLoadMoreView_WhenUserCountIsNotMultipleOfPageSizeShouldReturnFalse() {
        sut.users = Array(repeating: UserModelFixture.user1, count: 21) // Not a multiple of Constants.pageSize

        XCTAssertFalse(sut.shouldShowLoadMoreView())
    }

    func testShouldShowLoadMoreViewWhenUserCountIsLessThanPageSizeShouldReturnFalse() {
        sut.users = Array(repeating: UserModelFixture.user1, count: 10) // Less than Constants.pageSize

        XCTAssertFalse(sut.shouldShowLoadMoreView())
    }

    func testLoadUsersIfNeededWhenShouldInvokeIsTrueShouldCallInvoke() async throws {
        let expectation = self.expectation(description: "")
        loadUsers.shouldInvokeAtClosure = { _ in
            true
        }
        loadUsers.invokeAtClosure = { _ in
            expectation.fulfill()
        }

        sut.loadUsersIfNeeded(at: 0)

        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertTrue(loadUsers.invokeAtCalled)
    }

    func testDidTapUserShouldCallNavigateToDetail() {
        coordinator.navigateToDetailUsernameClosure = { username in
            XCTAssertEqual(username, UserModelFixture.user1.username)
        }
        sut.didTapUser(UserModelFixture.user1)
        XCTAssertTrue(coordinator.navigateToDetailUsernameCalled)
    }

}
