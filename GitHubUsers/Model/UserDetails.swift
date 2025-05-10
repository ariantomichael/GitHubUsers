//
//  UserDetails.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/11.
//

struct UserDetails: Decodable {
    let login: String
    let avatarUrl: String
    let name: String?
    let followers: Int
    let following: Int
    let reposUrl: String

    static var emptyDetails: UserDetails {
        UserDetails(login: "", avatarUrl: "", name: nil, followers: 0, following: 0, reposUrl: "")
    }
}
