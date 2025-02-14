//
//  Network+UserDetail.swift
//  Data
//
//  Created by Bao Nguyen on 12/2/25.
//

extension Network {
    struct UserDetail: Decodable, Equatable {
        let id: Int
        let login: String
        let avatar_url: String
        let html_url: String
        let location: String?
        let followers: Int
        let following: Int
    }
}
