//
//  User.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/10.
//

struct User: Decodable, Identifiable {
    let id: Int
    let login: String
    let avatarUrl: String
}
