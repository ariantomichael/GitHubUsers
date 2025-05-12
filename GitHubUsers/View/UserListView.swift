//
//  UserListView.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/08.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()

    var body: some View {
        NavigationSplitView {
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
            }.refreshable {
                Task {
                    await viewModel.loadUsers()
                }
            }
        } detail: {
            Text("Select a user")
        }
        .onAppear {
            Task {
                await viewModel.loadUsers()
            }
        }
    }
}
