//
//  AppCoordinator.swift
//  GithubUser
//
//  Created by Bao Nguyen on 13/2/25.
//

import SwiftUI

protocol GithubUserListCoordinator {
    func navigateToDetail(username: String)
}

final class AppCoordinator: ObservableObject, GithubUserListCoordinator {
    @Published var path: [AppRoute] = []

    enum AppRoute: Hashable {
        case home
        case detail(String)
    }

    func navigateToHome() {
        path = [.home]
    }

    func navigateToDetail(username: String) {
        path.append(.detail(username))
    }

    func resetNavigation() {
        path.removeAll()
    }

    @ViewBuilder
    func view(for route: AppRoute) -> some View {
        switch route {
            case .home:
                createGithubUserListView()
            case .detail(let username):
                createUserDetailView(username: username)
        }
    }
}


private extension AppCoordinator {
    func createGithubUserListView() -> GithubUserListView {
        let loadUsers = DIContainer.instance.dependencies.useCaseDependencies.loadUsers
        let getUsers = DIContainer.instance.dependencies.useCaseDependencies.getUsers

        let viewModel = GithubUserListViewModel(
            loadUsers: loadUsers,
            getUsers: getUsers,
            coordinator: self
        )
        return GithubUserListView(viewModel: viewModel)
    }

    func createUserDetailView(username: String) -> UserDetailView {
        let loadUserDetail = DIContainer.instance.dependencies.useCaseDependencies.loadUserDetail
        let getUserDetail = DIContainer.instance.dependencies.useCaseDependencies.getUserDetail

        let viewModel = UserDetailViewModel(
            username: username,
            loadUserDetail: loadUserDetail,
            getUserDetail: getUserDetail
        )
        return UserDetailView(viewModel: viewModel)
    }
}
