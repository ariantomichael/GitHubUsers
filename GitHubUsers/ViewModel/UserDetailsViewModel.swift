//
//  UserDetailsViewModel.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/11.
//

import Foundation

@MainActor
class UserDetailsViewModel: ObservableObject {

    @Published private(set) var userDetails = UserDetails.emptyDetails
    let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func loadUserDetails(userId: Int) async {
        do {
            userDetails = try await apiClient.fetchUserDetails(userId: userId)
        } catch {
            print(error)
        }
    }
}
