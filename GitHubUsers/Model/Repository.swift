//
//  Repository.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/11.
//

struct Repository: Decodable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let fork: Bool
    let language: String?
    let stargazersCount: Int
    let htmlUrl: String
}
