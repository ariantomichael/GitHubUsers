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
    let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func loadUsers() async {
        do {
            users = try await apiClient.fetchUsers()
        } catch {
            print(error)
        }
    }
}
