//
//  Network+User.swift
//  APINetwork
//
//  Created by Bao Nguyen on 12/2/25.
//

extension Network {
    struct User: Decodable, Equatable {
        let id: Int
        let login: String
        let avatar_url: String
        let html_url: String
    }
}
