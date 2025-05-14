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
    @Published private(set) var repositories: [Repository] = []
    @Published private(set) var nextPageUrl: String?
    var webViewUrlString: String?

    let apiClient: UserDetailsAPIClientProtocol

    init(apiClient: UserDetailsAPIClientProtocol = UserDetailsAPIClient()) {
        self.apiClient = apiClient
    }

    func loadUserDetails(userId: Int) async throws {
        userDetails = try await apiClient.userDetails(userId: userId)
        repositories.removeAll()
        nextPageUrl = userDetails.reposUrl
    }

    func loadNextPageOfRepositories() async throws {
        guard let nextPageUrl else { return }
        let res = try await apiClient.userRepositoriesAndLink(urlString: nextPageUrl)
        repositories.append(contentsOf: res.0.filter { $0.fork == false })
        self.nextPageUrl = extractNextURL(from: res.1)
    }

    private func extractNextURL(from linkHeader: String?) -> String? {
        guard let linkHeader else { return nil }
        let links = linkHeader.components(separatedBy: ", ")
        for link in links {
            if link.contains("rel=\"next\"") {
                if let start = link.firstIndex(of: "<"),
                    let end = link.lastIndex(of: ">")
                {
                    return String(link[start...end].dropLast().dropFirst())
                }
            }
        }
        return nil
    }
}
