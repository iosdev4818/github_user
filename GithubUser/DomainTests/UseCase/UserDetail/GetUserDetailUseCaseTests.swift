//
//  GetUserDetailUseCaseTests.swift
//  DomainTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import XCTest
import Combine
@testable import Domain

final class GetUserDetailUseCaseTests: XCTestCase {

    func testInvokeReturnsUser() async {
        let expectedUser = UserModelFixture.user1

        let repositoryExpectation = self.expectation(description: "Repository")
        let repository = GithubRepositorySpy()
        repository.getUserDetailUsernameClosure = { username in
            XCTAssertEqual(username, "username")
            repositoryExpectation.fulfill()
            return Just(expectedUser)
                .eraseToAnyPublisher()
        }

        let expectation = XCTestExpectation(description: "Get user detail")
        let sut = DefaultGetUserDetailUseCase(githubRepository: repository)

        let cancelable =  sut.invoke(username: "username")
            .sink { actualUser in
                XCTAssertEqual(actualUser, expectedUser)
                expectation.fulfill()
            }

        await fulfillment(of: [repositoryExpectation, expectation], timeout: 1.0)
        cancelable.cancel()
    }

    func testInvokeReturnsNil() async {
        let repositoryExpectation = self.expectation(description: "Repository")
        let repository = GithubRepositorySpy()
        repository.getUserDetailUsernameClosure = { username in
            XCTAssertEqual(username, "username")
            repositoryExpectation.fulfill()
            return Just(nil)
                .eraseToAnyPublisher()
        }

        let expectation = XCTestExpectation(description: "Get user detail")
        let sut = DefaultGetUserDetailUseCase(githubRepository: repository)

        let cancelable =  sut.invoke(username: "username")
            .sink { actualUser in
                XCTAssertNil(actualUser)
                expectation.fulfill()
            }

        await fulfillment(of: [repositoryExpectation, expectation], timeout: 1.0)
        cancelable.cancel()
    }

}
