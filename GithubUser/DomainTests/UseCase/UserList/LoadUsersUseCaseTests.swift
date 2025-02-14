//
//  LoadUsersUseCaseTests.swift
//  DomainTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import XCTest
@testable import Domain

final class LoadUsersUseCaseTests: XCTestCase {

    var repository: GithubRepositorySpy!
    var sut: LoadUsersUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        repository = GithubRepositorySpy()
        sut = DefaultLoadUsersUseCase(githubRepository: repository)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        repository = nil
        sut = nil
    }

    // MARK: - shouldInvoke
    func testShouldInvokeWhenIndexIsZeroAndUsersCountIsZero() {
        repository.getUsersCountClosure = {
            0
        }

        XCTAssertTrue(sut.shouldInvoke(at: 0))
    }

    func testShouldNotInvokeWhenIndexIsZeroAndUsersCountIsGreaterThanZero() {
        repository.getUsersCountClosure = {
            10
        }

        XCTAssertFalse(sut.shouldInvoke(at: 0))
    }

    func testShouldInvokeWhenIndexIsEqualToUsersCountMinusOne() {
        repository.getUsersCountClosure = {
            20
        }

        XCTAssertTrue(sut.shouldInvoke(at: 19))
    }

    func testShouldNotInvokeWhenIndexIsNotEqualToUsersCountMinusOne() {
        repository.getUsersCountClosure = {
            20
        }
        XCTAssertFalse(sut.shouldInvoke(at: 18))
    }

    func testShouldNotInvokeWhenIndexIsAlreadyInQueue() async throws {
        repository.getUsersCountClosure = {
            20
        }

        XCTAssertTrue(sut.shouldInvoke(at: 19))
        try await sut.invoke(at: 19)
        XCTAssertFalse(sut.shouldInvoke(at: 19))
    }

    // MARK: - invoke
    func testInvokeSuccess() async throws {
        let index = 39
        repository.loadUsersLimitOffsetClosure = { limit, offset in
            XCTAssertEqual(limit, 20)
            XCTAssertEqual(offset, index + 1)
        }

        try await sut.invoke(at: index)
    }

    func testInvokeFailure() async {
        let index = 39
        repository.loadUsersLimitOffsetClosure = { limit, offset in
            XCTAssertEqual(limit, 20)
            XCTAssertEqual(offset, index + 1)
            throw URLError(.timedOut)
        }

        do {
            try await sut.invoke(at: index)
            XCTFail("Must not call")
        } catch {
            XCTAssertEqual((error as! URLError).code, .timedOut)
        }
    }
}
