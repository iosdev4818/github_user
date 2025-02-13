//
//  GithubUserListView.swift
//  GithubUser
//
//  Created by Bao Nguyen on 13/2/25.
//

import SwiftUI
import Data

struct GithubUserListView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                Task {
                    try await DependenciesHolder.instance.dependencies.repositoryDependencies.githubRepository.loadUsers(limit: 20, offset: 0)
                }
            }
    }
}

#Preview {
    GithubUserListView()
}
