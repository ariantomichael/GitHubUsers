//
//  UserListViewModelTests.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/14.
//

import Foundation
import Testing

@testable import GitHubUsers

struct UserListViewModelTests {

    @Test func testLoadUsers() async throws {
        let mockApiClient = MockUserListAPIClient()
        let viewModel = await UserListViewModel(apiClient: mockApiClient)
        await #expect(viewModel.users.isEmpty)

        mockApiClient.users = [
            User(id: 1, login: "mike", avatarUrl: "aaa"),
            User(id: 2, login: "jane", avatarUrl: "bbb"),
            User(id: 3, login: "john", avatarUrl: "https://example.com/john.png"),
        ]
        try await viewModel.loadUsers()

        await #expect(viewModel.users.count == 3)
        await #expect(viewModel.users[0].login == "mike")
        await #expect(viewModel.users[0].avatarUrl == "aaa")
        await #expect(viewModel.users[1].id == 2)
        await #expect(viewModel.users[2].login == "john")
        await #expect(viewModel.users[2].avatarUrl == "https://example.com/john.png")
    }

    @Test func testError() async throws {
        let mockApiClient = MockUserListAPIClient()
        let viewModel = await UserListViewModel(apiClient: mockApiClient)

        mockApiClient.error = URLError(.badServerResponse)

        let error = await #expect(throws: URLError.self) {
            try await viewModel.loadUsers()
        }
        #expect(error?.code == URLError.badServerResponse)
    }
}
