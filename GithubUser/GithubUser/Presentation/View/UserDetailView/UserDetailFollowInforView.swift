//
//  UserDetailFollowInforView.swift
//  GithubUser
//
//  Created by Bao Nguyen on 14/2/25.
//

import SwiftUI

struct UserDetailFollowInforView: View {
    let follower: Int
    let following: Int

    var body: some View {
        HStack {
            Spacer()
            FollowInforView(follow: follower, title: "Follower", icon: "person.2.fill")
            Spacer()
            FollowInforView(follow: following, title: "Following", icon: "rosette")
            Spacer()
        }
    }
}

struct FollowInforView: View {
    let follow: Int
    let title: String
    let icon: String

    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .padding(16)
                .background(.gray)
                .clipShape(Circle())

            Text("\(follow)+")

            Text(title)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    UserDetailFollowInforView(follower: 100, following: 10)
}
