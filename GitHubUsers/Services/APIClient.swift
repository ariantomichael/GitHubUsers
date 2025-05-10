//
//  APIClient.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/08.
//

import Foundation

struct APIClient {

    let token =
        "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"

    func fetchUsers() async throws -> [User] {
        var request = URLRequest(
            url: URL(string: "https://api.github.com/users")!
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue(
            "2022-11-28",
            forHTTPHeaderField: "X-GitHub-Api-Version"
        )
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([User].self, from: data)
    }

    func fetchUserDetails(userId: Int) async throws -> UserDetails {
        var request = URLRequest(
            url: URL(string: "https://api.github.com/user/\(userId)")!
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue(
            "2022-11-28",
            forHTTPHeaderField: "X-GitHub-Api-Version"
        )
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(UserDetails.self, from: data)
    }
}
