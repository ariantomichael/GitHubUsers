//
//  UserDetailsAPIClient.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/13.
//

import Foundation

struct UserDetailsAPIClient: BaseAPIClientProtocol, UserDetailsAPIClientProtocol {

    func userDetails(userId: Int) async throws -> UserDetails {
        guard let request = gitHubRequest(urlString: "\(apiBaseEndPoint)/user/\(userId)") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode(UserDetails.self, from: data)
    }

    func userRepositoriesAndLink(urlString: String) async throws -> ([Repository], String?) {
        guard let request = gitHubRequest(urlString: urlString) else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        let repositories = try decoder.decode([Repository].self, from: data)
        let link = (response as? HTTPURLResponse)?.value(forHTTPHeaderField: "Link")
        return (repositories, link)
    }
}
