//
//  GithubUserListView.swift
//  GithubUser
//
//  Created by Bao Nguyen on 13/2/25.
//

import SwiftUI
import Domain

struct GithubUserListView: View {
    @StateObject var viewModel: GithubUserListViewModel

    var body: some View {
        List {
            ForEach(Array(viewModel.users.enumerated()), id: \.element) { index, user in
                UserRowView(viewModel: UserRowViewModel(user: user))
                    .listRowSeparator(.hidden)
                    .onAppear {
                        viewModel.loadUsersIfNeeded(at: index)
                    }
                    .onTapGesture {
                        viewModel.didTapUser(user)
                    }
            }

            if viewModel.shouldShowLoadMoreView() {
                LoadMoreCell()
                    .id(UUID())
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .onAppear {
            viewModel.startUpdating()
        }
        .onDisappear {
            viewModel.stopUpdating()
        }
        .navigationTitle(R.string.localizable.github_users())
        .navigationBarTitleDisplayMode(.inline)
    }
}
