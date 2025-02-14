//
//  UserDetailView.swift
//  GithubUser
//
//  Created by Bao Nguyen on 14/2/25.
//

import SwiftUI

struct UserDetailView: View {
    @StateObject var viewModel: UserDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let user = viewModel.user {
                    UserDetailRowView(
                        avatarUrl: user.avatarURL,
                        displayName: user.username,
                        location: user.location
                    )

                    UserDetailFollowInforView(follower: user.follower, following: user.following)

                    UserDetailBlogView(blog: user.htmlURL)
                }
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            viewModel.startUpdating()
        }
        .onDisappear {
            viewModel.stopUpdating()
        }
        .navigationTitle("User Details")
    }
}
