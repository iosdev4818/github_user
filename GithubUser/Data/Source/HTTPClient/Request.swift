//
//  Request.swift
//  APINetwork
//
//  Created by Bao Nguyen on 12/2/25.
//

internal import Spyable

@Spyable(accessLevel: .public)
public protocol Request {
    associatedtype ResponseModelType

    var httpMethod: HTTPMethod { get }
    var baseEndpoint: BaseEndpointType { get }
    var path: String? { get }
    var percentEncodedPath: String? { get }
    var queryParameters: [URLQueryItem]? { get }
    var body: RequestBody? { get }
    var timeoutInterval: TimeInterval? { get }
    var cachePolicy: URLRequest.CachePolicy? { get }

    func decode(_ output: (data: Data, response: URLResponse)) throws -> ResponseModelType
}

extension Request {
    var path: String? { nil }
    var percentEncodedPath: String? { nil }
    var queryParameters: [URLQueryItem]? { nil }
    var body: RequestBody? { nil }
    var timeoutInterval: TimeInterval? { nil }
    var cachePolicy: URLRequest.CachePolicy? { nil }
}

extension Request {
    public func toUrlRequest(baseEndpointProvider: BaseEndpointProvider) throws -> URLRequest {
        var urlComponents = try urlComponents(using: baseEndpointProvider)

        switch (path, percentEncodedPath) {
        case (nil, nil):
            fatalError("Path and percentEncodedPath cannot both be nil")
        case (nil, percentEncodedPath):
            guard let urlPercentEncodedPath = percentEncodedPath, isPathValid(urlPercentEncodedPath) else {
                fatalError("Invalid percentEncodedPath ")
            }
            urlComponents.percentEncodedPath += urlPercentEncodedPath
        case (path, nil):
            guard let urlPath = path, isPathValid(urlPath) else {
                fatalError("Invalid path ")
            }
            urlComponents.path += urlPath
        case (_, _):
            fatalError("Path and percentEncodedPath cannot both be set")
        }

        if let queryParameters = queryParameters {
            urlComponents.percentEncodedQueryItems = (urlComponents.percentEncodedQueryItems ?? []) + queryParameters.map { queryParameter in
                URLQueryItem(name: queryParameter.name, value: queryParameter.value?.addingPercentEncoding(withAllowedCharacters: .alphanumerics))
            }
        }

        guard let url = urlComponents.url else {
            fatalError("Cannot rebuild url from urlComponents")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        urlRequest.cachePolicy = cachePolicy ?? .reloadIgnoringLocalCacheData
        if let body = self.body {
            urlRequest.setValue(body.contentType, forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try body.encode()
        }
        if let timeoutInterval = timeoutInterval {
            urlRequest.timeoutInterval = timeoutInterval
        }
        return urlRequest
    }

    private func isPathValid(_ path: String) -> Bool {
        guard !path.isEmpty else {
            fatalError("Missing path in url request")
        }

        guard path.hasPrefix("/") else {
            fatalError("Path \(path) doesn't start with a /")
        }

        return true
    }

    private func urlComponents(using baseEndpointProvider: BaseEndpointProvider) throws -> URLComponents {
        let baseEndpointString = baseEndpointProvider.endpoint(for: baseEndpoint)
        guard let urlComponents = URLComponents(string: baseEndpointString) else {
            throw URLError(.badURL)
        }

        guard urlComponents.host != nil, urlComponents.scheme != nil else {
            throw URLError(.badURL)
        }

        return urlComponents
    }
}
