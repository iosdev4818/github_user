# ``APINetwork``

<!--@START_MENU_TOKEN@-->HTTPClient is the base class for communicating with an external network<!--@END_MENU_TOKEN@-->

## Quick Start
1. Get instance of HTTPClient
```Swift
let httpClient = DefaultHTTPClient(baseEndpointProvider: DefaultBaseEndpointProvider(), session: urlSession)
```
2. Create an API request, conform the `Request` protocol, and call it
```Swift
final class UserRequest: JSONDecodableRequest<[Network.User]> {
    init(limit: Int, offset: Int) {
        super.init(
            httpMethod: .GET,
            baseEndpoint: .github,
            path: "/users",
            queryParameters: [
                URLQueryItem(name: "per_page", value: String(limit)),
                URLQueryItem(name: "since", value: String(offset))
            ]
        )
    }
}

let output = try await httpClient.execute(request: request)
```