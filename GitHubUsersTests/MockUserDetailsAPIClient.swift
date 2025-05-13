//
//  MockUserDetailsAPIClient.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/13.
//

@testable import GitHubUsers

class MockUserDetailsAPIClient: UserDetailsAPIClientProtocol {
    var error: Error?
    var userDetails: UserDetails?
    var userRepositoriesAndLink: ([Repository], String?)?

    func userDetails(userId: Int) async throws -> UserDetails {
        if let error {
            throw error
        }
        return userDetails!  // it is okay to crash if nil just to let dev know that they forgot to set the mock UserDetails
    }

    func userRepositoriesAndLink(urlString: String) async throws -> ([Repository], String?) {
        if let error {
            throw error
        }
        return userRepositoriesAndLink!
    }
}
