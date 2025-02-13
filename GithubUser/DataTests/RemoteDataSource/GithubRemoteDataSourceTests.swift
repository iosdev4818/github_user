//
//  GithubRemoteDataSourceTests.swift
//  DataTests
//
//  Created by Bao Nguyen on 13/2/25.
//

import XCTest
@testable import Data

final class DefaultGithubRemoteDataSourceTests: BaseTests {

    func testLoadUsersCallsExecuteWithCorrectRequest() async throws {
        let httpClient = HTTPClientSpy()
        httpClient.executeClosure = { request in
            XCTAssertNotNil(request as? UserRequest)

            return (self.dataWithName("github_users_response", ofType: "json")!, HTTPURLResponse())
        }

        let sut = DefaultGithubRemoteDataSource(httpClient: httpClient)

        let results = try await sut.loadUsers(limit: 20, offset: 0)

        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results, [
            Network.UserFixture.user1,
            Network.UserFixture.user2
        ])
    }

    func testLoadUsersThrowsError() async throws {
        let httpClient = HTTPClientSpy()
        httpClient.executeClosure = { request in
            XCTAssertNotNil(request as? UserRequest)

            throw URLError(.timedOut)
        }

        let sut = DefaultGithubRemoteDataSource(httpClient: httpClient)

        do {
            _ = try await sut.loadUsers(limit: 20, offset: 0)
            XCTFail("Must not call")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .timedOut)
        }
    }

    func testLoadUserDetailCallsExecuteWithCorrectRequest() async throws {
        let httpClient = HTTPClientSpy()
        httpClient.executeClosure = { request in
            XCTAssertNotNil(request as? UserDetailRequest)

            return (self.dataWithName("github_user_detail_response", ofType: "json")!, HTTPURLResponse())
        }

        let sut = DefaultGithubRemoteDataSource(httpClient: httpClient)

        let result = try await sut.loadUserDetail(username: "test")

        XCTAssertEqual(result, Network.UserDetailFixture.user1)
    }

    func testLoadUserDetailThrowsError() async throws {
        let httpClient = HTTPClientSpy()
        httpClient.executeClosure = { request in
            XCTAssertNotNil(request as? UserDetailRequest)

            throw URLError(.timedOut)
        }

        let sut = DefaultGithubRemoteDataSource(httpClient: httpClient)

        do {
            _ = try await sut.loadUserDetail(username: "test")
            XCTFail("Must not call")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .timedOut)
        }
    }
}

