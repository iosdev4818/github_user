//
//  JSONDecodableRequest.swift
//  APINetwork
//
//  Created by Bao Nguyen on 12/2/25.
//

/// Decoder for JSON responses
class JSONDecodableRequest<ResponseModelType: Decodable>: Request {
    let httpMethod: HTTPMethod
    let baseEndpoint: BaseEndpointType
    let path: String?
    let percentEncodedPath: String?
    let queryParameters: [URLQueryItem]?
    let body: RequestBody?

    init(
        httpMethod: HTTPMethod,
        baseEndpoint: BaseEndpointType,
        path: String? = nil,
        percentEncodedPath: String? = nil,
        queryParameters: [URLQueryItem]? = nil,
        body: RequestBody? = nil
    ) {
        self.httpMethod = httpMethod
        self.baseEndpoint = baseEndpoint
        self.path = path
        self.percentEncodedPath = percentEncodedPath
        self.queryParameters = queryParameters
        self.body = body
    }

    /// Handle rdecode Data to JSON
    /// - Parameter output: output from HTTPClient
    /// - Returns: JSON model
    func decode(_ output: (data: Data, response: URLResponse)) throws -> ResponseModelType {
        let requestPath = output.response.url?.relativeString

        return try decodeResponseBody(output.data, requestPath: requestPath)
    }

    /// Decode from Data to JSON object
    /// - Parameters:
    ///   - data: Data
    ///   - requestPath: url path
    /// - Returns: JSON data model
    private func decodeResponseBody<ResponseBodyType>(_ data: Data, requestPath: String?) throws -> ResponseBodyType where ResponseBodyType: Decodable {
        do {
            return try JSONDecoder().decode(ResponseBodyType.self, from: data)
        } catch {
            let receivedString = String(data: data, encoding: .utf8) ?? "Binary data"
            let errorMsg = "\(#function) Error \(error) decoding API response for request \(requestPath ?? "<no url path>"): expected \(String(describing: ResponseModelType.self)), but received \(receivedString)"
            debugPrint(errorMsg)

            throw URLError(.cannotParseResponse)
        }
    }
}
