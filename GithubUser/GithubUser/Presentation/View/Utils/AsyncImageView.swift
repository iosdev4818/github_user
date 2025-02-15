//
//  AsyncImageView.swift
//  GithubUser
//
//  Created by Bao Nguyen on 13/2/25.
//

import SwiftUI

struct AsyncImageView: View {
    let urlString: String

    var body: some View {
        if let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                    case .empty:
                        ProgressView()
                            .progressViewStyle(.circular)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Color(.systemGray6)
                    @unknown default:
                        Color(.systemGray6)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fill)
            .clipped()
        } else {
            Color(.systemGray6)
        }
    }
}

#Preview {
    VStack {
        VStack {
            AsyncImageView(urlString: "https://avatars.githubusercontent.com/u/44?v=4")
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
}
