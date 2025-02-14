//
//  LoadUserDetailUseCaseTests.swift
//  DomainTests
//
//  Created by Bao Nguyen on 14/2/25.
//

import XCTest
@testable import Domain

final class LoadUserDetailUseCaseTests: XCTestCase {

    func testInvokeReturnSuccess() async throws {
        let repositoryExpectation = self.expectation(description: "Repository")
        let repository = GithubRepositorySpy()
        repository.loadUserDetailUsernameClosure = { username in
            XCTAssertEqual(username, "username")
            repositoryExpectation.fulfill()
        }

        let sut = DefaultLoadUserDetailUseCase(githubRepository: repository)

        try await sut.invoke("username")

        await fulfillment(of: [repositoryExpectation], timeout: 1.0)
    }

    func testInvokeThrowError() async throws {
        let repository = GithubRepositorySpy()
        repository.loadUserDetailUsernameClosure = { username in
            XCTAssertEqual(username, "username")
            throw URLError(.timedOut)
        }

        let sut = DefaultLoadUserDetailUseCase(githubRepository: repository)

        do {
            try await sut.invoke("username")
            XCTFail("Must not call")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .timedOut)
        }
    }
}
