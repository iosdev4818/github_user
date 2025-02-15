//
//  AsyncImageView.swift
//  GithubUser
//
//  Created by Bao Nguyen on 13/2/25.
//

import SwiftUI
import Kingfisher

struct AsyncImageView: View {
    let urlString: String

    var body: some View {
        KFImage.url(URL(string: urlString))
            .placeholder {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fill)
            .clipped()
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
