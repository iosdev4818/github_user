//
//  UserDetailRowView.swift
//  GithubUser
//
//  Created by Bao Nguyen on 14/2/25.
//

import SwiftUI

struct UserDetailRowView: View {
    let avatarUrl: String
    let displayName: String
    let location: String

    var body: some View {
        HStack(alignment: .top) {
            Group {
                AsyncImageView(urlString: avatarUrl)
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                VStack(alignment: .leading) {
                    Text(displayName)
                        .font(.title2)
                        .lineLimit(2)
                        .bold()
                    Divider()
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text(location)
                            .lineLimit(2)
                    }
                }
            }
            .padding(10)
        }
        .background(.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
    }
}
