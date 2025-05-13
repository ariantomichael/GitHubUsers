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
                avatar
                userDetails
                Spacer().frame(height: 12)
                repositories
                if viewModel.nextPageUrl != nil {
                    ProgressView()
                }
            }
            .padding(.horizontal, 16)
        }
        .refreshable {
            Task {
                await viewModel.loadUserDetails(userId: id)
                await viewModel.loadNextPageOfRepositories()
            }
        }
        .sheet(isPresented: $isWebViewPresented) {
            webViewModal
        }
        .onAppear {
            Task {
                await viewModel.loadUserDetails(userId: id)
                await viewModel.loadNextPageOfRepositories()
            }
        }
    }

    @ViewBuilder
    private var avatar: some View {
        AsyncImage(url: URL(string: viewModel.userDetails.avatarUrl)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 240)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(Color.gray))
        } placeholder: {
            ProgressView()
        }
    }

    @ViewBuilder
    private var userDetails: some View {
        Text(viewModel.userDetails.login)
            .font(.title)
            .fontWeight(.bold)
        if let name = viewModel.userDetails.name {
            Text(name)
        }
        Spacer().frame(height: 4)
        Text(
            "\(viewModel.userDetails.followers) followers · \(viewModel.userDetails.following) following"
        )
        .font(.subheadline)
        .foregroundColor(.secondary)
    }

    @ViewBuilder
    private var repositories: some View {
        ForEach(viewModel.repositories) { repository in
            Button {
                viewModel.webViewUrlString = repository.htmlUrl
                isWebViewPresented = true
            } label: {
                VStack(alignment: .leading) {
                    HStack {
                        VStack {
                            Text(repository.name)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        Text(
                            "\(repository.stargazersCount) \(Image(systemName: "star.fill").renderingMode(.template))"
                        )
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    if let language = repository.language {
                        Text(language)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    if let description = repository.description {
                        Text(description)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                            .truncationMode(.tail)
                            .multilineTextAlignment(.leading)
                    }
                    Divider()
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
    }

    @ViewBuilder
    private var webViewOrBadUrlText: some View {
        if let webViewUrlString = viewModel.webViewUrlString,
            let url = URL(string: webViewUrlString)
        {
            WebView(url: url)
        } else {
            Text("Bad URL")
        }
    }

    @ViewBuilder
    private var webViewModal: some View {
        NavigationView {
            webViewOrBadUrlText
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            isWebViewPresented = false
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
        }
    }
}
