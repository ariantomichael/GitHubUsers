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
    @State private var isWebViewPresented: Bool = false

    var body: some View {
        ScrollView {
            LazyVStack {
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
                ForEach(viewModel.repositories) { repository in
                    Button {
                        viewModel.webViewUrlString = repository.htmlUrl
                        isWebViewPresented = true
                    } label: {
                        VStack {
                            Text(repository.name)
                            if let language = repository.language {
                                Text(language)
                            }
                            Text("Star: \(repository.stargazersCount)")
                            if let description = repository.description {
                                Text(description)
                            }
                        }
                    }
                    .onAppear {
                        if repository.id == viewModel.repositories.last?.id {
                            Task {
                                await viewModel.loadNextPageOfRepositories()
                            }
                        }
                    }
                }
                if viewModel.nextPageUrl != nil {
                    ProgressView()
                }
            }
        }
        .sheet(isPresented: $isWebViewPresented) {
            NavigationView {
                if let webViewUrlString = viewModel.webViewUrlString,
                    let url = URL(string: webViewUrlString)
                {
                    WebView(url: url)
                } else {
                    Text("Bad URL")
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadUserDetails(userId: id)
                await viewModel.loadNextPageOfRepositories()
            }
        }
    }
}
