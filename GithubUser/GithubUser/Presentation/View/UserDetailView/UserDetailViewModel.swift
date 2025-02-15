//
//  UserDetailViewModel.swift
//  GithubUser
//
//  Created by Bao Nguyen on 14/2/25.
//

import Domain
import SwiftUI
import Combine

final class UserDetailViewModel: ObservableObject {
    @Published var user: UserModel?

    private let username: String
    private let loadUserDetail: LoadUserDetailUseCase
    private let getUserDetail: GetUserDetailUseCase

    private var getUserDetailPublisher: AnyCancellable?

    init(
        username: String,
        loadUserDetail: LoadUserDetailUseCase,
        getUserDetail: GetUserDetailUseCase
    ) {
        self.username = username
        self.loadUserDetail = loadUserDetail
        self.getUserDetail = getUserDetail

        fetchUserDetail()
    }

    func startUpdating() {
        getUserDetailPublisher?.cancel()
        getUserDetailPublisher = nil

        getUserDetailPublisher = getUserDetail
            .invoke(username: username)
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                self?.user = user
            }
    }

    func stopUpdating() {
        getUserDetailPublisher?.cancel()
        getUserDetailPublisher = nil
    }

    private func fetchUserDetail() {
        Task {
            do {
                try await loadUserDetail.invoke(username)
            } catch {
                debugPrint("[UserDetailViewModel] fetchUserDetail error: \(error)")
            }
        }
    }
}
