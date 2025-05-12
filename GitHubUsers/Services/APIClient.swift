//
//  APIClient.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/08.
//

import Foundation

struct APIClient {

    private let token =
        "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"
    private let apiBaseEndPoint = "https://api.github.com"
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private func gitHubRequest(urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue(
            "2022-11-28",
            forHTTPHeaderField: "X-GitHub-Api-Version"
        )
        return request
    }

    func users() async throws -> [User] {
        guard let request = gitHubRequest(urlString: "\(apiBaseEndPoint)/users") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode([User].self, from: data)
    }

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
