//
//  UserRowView.swift
//  GithubUser
//
//  Created by Bao Nguyen on 13/2/25.
//

import SwiftUI

struct UserRowView: View {
    let viewModel: UserRowViewModel

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Group {
                    AsyncImageView(urlString: viewModel.avatarURL)
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
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
            .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .listRowInsets(EdgeInsets())
    }
}
