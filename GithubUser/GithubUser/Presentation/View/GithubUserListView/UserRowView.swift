//
//  UserRowView.swift
//  GithubUser
//
//  Created by Bao Nguyen on 13/2/25.
//

import SwiftUI

struct UserRowView: View {
    let viewModel: UserRowViewModel

    private struct Constants {
        static let imageSize: CGFloat = 100
    }

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Group {
                    AsyncImageView(urlString: viewModel.avatarURL)
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                        .clipShape(.circle)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .clipShape(.rect(cornerRadius: 16))

                    VStack(alignment: .leading) {
                        Text(viewModel.displayName)
                            .font(.title2)
                            .lineLimit(2)
                            .bold()

                        Divider()

                        Text("[\(viewModel.htmlURL)](\(viewModel.htmlURL))")
                    }
                }
                .padding(10)
            }
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.4), radius: 5, x: 1, y: 5)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .listRowInsets(EdgeInsets())
    }
}
