//
//  LoadMoreCell.swift
//  GithubUser
//
//  Created by Bao Nguyen on 13/2/25.
//

import SwiftUI

struct LoadMoreCell: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(.gray)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    LoadMoreCell()
}
