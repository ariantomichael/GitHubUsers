//
//  MockUserListAPIClient.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/14.
//

@testable import GitHubUsers

class MockUserListAPIClient: UserListAPIClientProtocol {
    var error: Error?
    var users: [User]?

    func users() async throws -> [User] {
        if let error {
            throw error
        }
        // it is okay to crash if nil just to let dev know that they forgot to set the mock users
        return users!
    }
}
