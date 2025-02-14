//
//  GetUsersUseCaseTests.swift
//  DomainTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import XCTest
import Combine
@testable import Domain

class GetUsersUseCaseTests: XCTestCase {

    func testInvokeReturnsUsers() async {
        let expectedUsers = [
            UserModelFixture.user1,
            UserModelFixture.user2
        ]

        let repositoryExpectation = self.expectation(description: "Repository")
        let repository = GithubRepositorySpy()
        repository.getUsersClosure = {
            repositoryExpectation.fulfill()
            return Just(expectedUsers)
                .eraseToAnyPublisher()
        }

        let expectation = XCTestExpectation(description: "Get users")
        let sut = DefaultGetUsersUseCase(githubRepository: repository)

        let cancelable =  sut.invoke()
            .sink { actualUsers in
                XCTAssertEqual(actualUsers, expectedUsers)
                expectation.fulfill()
            }

        await fulfillment(of: [repositoryExpectation, expectation], timeout: 1.0)
        cancelable.cancel()
    }

    func testInvokeReturnsEmptyList() async {
        let repositoryExpectation = self.expectation(description: "Repository")
        let repository = GithubRepositorySpy()
        repository.getUsersClosure = {
            repositoryExpectation.fulfill()
            return Just([])
                .eraseToAnyPublisher()
        }

        let expectation = XCTestExpectation(description: "Get empty users list")
        let sut = DefaultGetUsersUseCase(githubRepository: repository)

        let cancelable =  sut.invoke()
            .sink { actualUsers in
                XCTAssertTrue(actualUsers.isEmpty)
                expectation.fulfill()
            }

        await fulfillment(of: [repositoryExpectation, expectation], timeout: 1.0)
        cancelable.cancel()
    }
}

