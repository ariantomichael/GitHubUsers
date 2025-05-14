//
//  UserListViewModel.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/10.
//

import Foundation

@MainActor
class UserListViewModel: ObservableObject {

    @Published private(set) var users: [User] = []
    let apiClient: UserListAPIClientProtocol

    init(apiClient: UserListAPIClientProtocol = UserListAPIClient()) {
        self.apiClient = apiClient
    }

    func loadUsers() async throws {
        users = try await apiClient.users()
    }
}
