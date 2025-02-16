//
//  GithubUserListViewModel.swift
//  GithubUser
//
//  Created by Bao Nguyen on 13/2/25.
//

import Domain
import Combine
import SwiftUI

final class GithubUserListViewModel: ObservableObject {
    struct Constants {
        static let pageSize: Int = 20
    }

    @Published var users: [UserModel] = []
    @Published private var hasMoreUsersToLoad = true // Indicates if more User can be loaded

    private var getUsersPublisher: AnyCancellable?

    private let loadUsers: LoadUsersUseCase
    private let getUsers: GetUsersUseCase
    private let coordinator: GithubUserListCoordinator

    init(
        loadUsers: LoadUsersUseCase,
        getUsers: GetUsersUseCase,
        coordinator: GithubUserListCoordinator
    ) {
        self.loadUsers = loadUsers
        self.getUsers = getUsers
        self.coordinator = coordinator

        // Load first page
        loadUsersIfNeeded(at: 0)
    }

    // Start observing changes from CoreData
    func startUpdating() {
        getUsersPublisher?.cancel()
        getUsersPublisher = nil

        getUsersPublisher = getUsers
            .invoke()
            .receive(on: RunLoop.main)
            .sink { [weak self] users in
                self?.users = users
            }
    }

    // Stop observing changes from CoreData
    func stopUpdating() {
        getUsersPublisher?.cancel()
        getUsersPublisher = nil
    }

    func shouldShowLoadMoreView() -> Bool {
        hasMoreUsersToLoad &&
        users.count >= Constants.pageSize
        && users.count % Constants.pageSize == 0
    }

    // Check and perform load more action
    func loadUsersIfNeeded(at index: Int) {
        guard loadUsers.shouldInvoke(at: index) else {
            return
        }

        Task {
            do {
                try await loadUsers.invoke(at: index)
            } catch {
                debugPrint("[GithubUserListViewModel] loadUsersIfNeeded error: \(error)")
            }
        }
    }

    func refresh() {
        Task {
            do {
                try loadUsers.invalidate()
                loadUsersIfNeeded(at: 0)
            } catch {
                debugPrint("[GithubUserListViewModel] refresh error: \(error)")
            }
        }
    }
}

// MARK: - User Action
extension GithubUserListViewModel {
    func didTapUser(_ user: UserModel) {
        coordinator.navigateToDetail(username: user.username)
    }
}
