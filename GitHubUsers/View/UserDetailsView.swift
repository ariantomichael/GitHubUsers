//
//  UserDetailsView.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/11.
//

import SwiftUI

struct UserDetailsView: View {
    let id: Int
    @StateObject private var viewModel = UserDetailsViewModel()

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: viewModel.userDetails.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 240)
            } placeholder: {
                ProgressView()
            }
            Text(viewModel.userDetails.login)
            if let name = viewModel.userDetails.name {
                Text(name)
            }
            Text("Followers: \(viewModel.userDetails.followers)")
            Text("Following: \(viewModel.userDetails.following)")
        }
        .onAppear {
            Task {
                await viewModel.loadUserDetails(userId: id)
            }
        }
    }
}
