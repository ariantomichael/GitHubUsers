//
//  UserListAPIClient.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/08.
//

import Foundation

struct UserListAPIClient: BaseAPIClientProtocol, UserListAPIClientProtocol {

    func users() async throws -> [User] {
        guard let request = gitHubRequest(urlString: "\(apiBaseEndPoint)/users") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode([User].self, from: data)
    }
}
