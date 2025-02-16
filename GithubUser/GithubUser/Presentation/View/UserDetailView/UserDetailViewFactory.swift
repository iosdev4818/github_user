//
//  UserDetailViewFactory.swift
//  GithubUser
//
//  Created by Bao Nguyen on 16/2/25.
//

struct UserDetailViewFactory {
    static func make(username: String) -> UserDetailView {
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
