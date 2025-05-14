//
//  APIClientProtocol.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/13.
//

import Foundation

protocol BaseAPIClientProtocol {}

extension BaseAPIClientProtocol {
    private var token: String? {
        // input your own GitHub app token
        return nil
    }

    var apiBaseEndPoint: String {
        return "https://api.github.com"
    }

    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    func gitHubRequest(urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.setValue(
            "2022-11-28",
            forHTTPHeaderField: "X-GitHub-Api-Version"
        )
        return request
    }
}

protocol UserListAPIClientProtocol {
    func users() async throws -> [User]
}

protocol UserDetailsAPIClientProtocol {
    func userDetails(userId: Int) async throws -> UserDetails
    func userRepositoriesAndLink(urlString: String) async throws -> ([Repository], String?)
}
