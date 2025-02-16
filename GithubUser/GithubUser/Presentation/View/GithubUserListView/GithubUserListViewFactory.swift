//
//  GithubUserListViewFactory.swift
//  GithubUser
//
//  Created by Bao Nguyen on 16/2/25.
//

struct GithubUserListViewFactory {
    static func make(coordinator: GithubUserListCoordinator) -> GithubUserListView {
        let loadUsers = DIContainer.instance.dependencies.useCaseDependencies.loadUsers
        let getUsers = DIContainer.instance.dependencies.useCaseDependencies.getUsers

        let viewModel = GithubUserListViewModel(
            loadUsers: loadUsers,
            getUsers: getUsers,
            coordinator: coordinator
        )
        return GithubUserListView(viewModel: viewModel)
    }
}
