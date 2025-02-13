//
//  AppCoordinator.swift
//  GithubUser
//
//  Created by Bao Nguyen on 13/2/25.
//

import SwiftUI

final class AppCoordinator: ObservableObject {
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
                GithubUserListView()
            case .detail(let username):
                ContentView()
        }
    }
}

