//
//  JsonBody.swift
//  APINetwork
//
//  Created by Bao Nguyen on 12/2/25.
//

struct JsonBody {
    let json: Encodable
    init(_ json: Encodable) {
        self.json = json
    }
}

extension JsonBody: RequestBody {
    var contentType: String {
        "application/json; charset=utf-8"
    }

    func encode() throws -> Data {
        try self.json.toJSONData()
    }
}

extension Encodable {
    func toJSONData() throws -> Data {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .withoutEscapingSlashes
        return try jsonEncoder.encode(self)
    }

    func toJSONBody() -> JsonBody {
        JsonBody(self)
    }
}
