//
//  UserDetailBlogView.swift
//  GithubUser
//
//  Created by Bao Nguyen on 14/2/25.
//

import SwiftUI

struct UserDetailBlogView: View {
    let blog: String

    var body: some View {
        VStack(alignment: .leading) {
            Text("Blog")
                .font(.title2)
                .bold()

            Text(blog)
        }
    }
}

#Preview {
    UserDetailBlogView(blog: "https://example")
}
