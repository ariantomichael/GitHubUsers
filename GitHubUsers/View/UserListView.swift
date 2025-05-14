//
//  UserListView.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/08.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()
    @State private var isFirstLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationSplitView {
            if isFirstLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else {
                userList
                    .navigationTitle(Text("GitHub Users"))
                    .refreshable {
                        Task {
                            do {
                                try await viewModel.loadUsers()
                            } catch {
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
            }
            if errorMessage != nil {
                ToastView(message: $errorMessage)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        } detail: {
            Text("Select a user")
        }
        .onAppear {
            Task {
                do {
                    try await viewModel.loadUsers()
                } catch {
                    errorMessage = error.localizedDescription
                }
                isFirstLoading = false
            }
        }
    }

    @ViewBuilder
    private var userList: some View {
        if viewModel.users.isEmpty {
            ScrollView {  // wrap with ScrollView to make it refreshable
                Text("No users found")
                    .padding(.top, 120)
            }
        } else {
            List {
                ForEach(viewModel.users) { user in
                    NavigationLink {
                        UserDetailsView(id: user.id)
                    } label: {
                        HStack {
                            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                                image
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                            Text(user.login)
                        }
                    }
                }
            }
        }
    }
}
