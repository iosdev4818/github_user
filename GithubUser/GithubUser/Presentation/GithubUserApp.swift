//
//  GithubUserApp.swift
//  GithubUser
//
//  Created by Bao Nguyen on 12/2/25.
//

import SwiftUI

@main
struct GithubUserApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @StateObject private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.view(for: .home)
                    .navigationDestination(for: AppCoordinator.AppRoute.self) { route in
                        coordinator.view(for: route)
                    }
            }
        }
    }
}
