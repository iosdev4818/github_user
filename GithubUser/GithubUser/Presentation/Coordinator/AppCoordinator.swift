//
//  AppCoordinator.swift
//  GithubUser
//
//  Created by Bao Nguyen on 13/2/25.
//

import SwiftUI
import Spyable

@Spyable(behindPreprocessorFlag: "DEBUG || TESTING")
protocol GithubUserListCoordinator {
    /// Navigate to user detail
    /// - Parameter username: username of user
    func navigateToDetail(username: String)
}

/// Main Coordinator of the application
/// This will manage and handle navigation
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
            GithubUserListViewFactory.make(coordinator: self)
        case .detail(let username):
            UserDetailViewFactory.make(username: username)
        }
    }
}
