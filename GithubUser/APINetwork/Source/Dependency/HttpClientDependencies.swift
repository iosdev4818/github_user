//
//  HttpClientDependencies.swift
//  APINetwork
//
//  Created by Bao Nguyen on 12/2/25.
//

import Data

private enum HTTPClientConstant {
    static let memoryCapacity = 10 * 1024 * 1024  // 10 MB in memory
    static let diskCapacity = 50 * 1024 * 1024    // 50 MB on disk
    static let diskPath = "github_user"
    static let timeoutIntervalForRequest = 30.0   // 30 seconds timeout for each request
    static let timeoutIntervalForResource = 60.0  // 60 seconds for overall request
    static let httpMaximumConnectionsPerHost = 5
}

final class DefaultHttpClientDependencies: HttpClientDependencies {
    private let baseEndpointProvider: BaseEndpointProvider

    init(baseEndpointProvider: BaseEndpointProvider) {
        self.baseEndpointProvider = baseEndpointProvider
    }

    lazy var httpClient: HTTPClient = {
        DefaultHTTPClient(
            baseEndpointProvider: baseEndpointProvider,
            session: urlSession
        )
    }()

    private lazy var urlSession: URLSession = {
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.urlCache = URLCache(
            memoryCapacity: HTTPClientConstant.memoryCapacity,
            diskCapacity: HTTPClientConstant.diskCapacity,
            diskPath: HTTPClientConstant.diskPath
        )
        urlSessionConfiguration.timeoutIntervalForRequest = HTTPClientConstant.timeoutIntervalForRequest
        urlSessionConfiguration.timeoutIntervalForResource = HTTPClientConstant.timeoutIntervalForResource
        urlSessionConfiguration.httpMaximumConnectionsPerHost = HTTPClientConstant.httpMaximumConnectionsPerHost

        return URLSession(
            configuration: urlSessionConfiguration,
            delegate: nil,
            delegateQueue: nil
        )
    }()
}

public final class HttpClientDependenciesFactory {
    public static func make() -> HttpClientDependencies {
        DefaultHttpClientDependencies(baseEndpointProvider: DefaultBaseEndpointProvider())
    }
}
