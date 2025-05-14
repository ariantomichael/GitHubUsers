//
//  UserDetailsViewModelTests.swift
//  GitHubUsersTests
//
//  Created by Michael Arianto on 2025/05/08.
//

import Testing

@testable import GitHubUsers

struct UserDetailsViewModelTests {

    @Test func testLoadUserDetails() async throws {
        let mockApiClient = MockUserDetailsAPIClient()
        let viewModel = await UserDetailsViewModel(apiClient: mockApiClient)
        await #expect(viewModel.userDetails.login.isEmpty)
        await #expect(viewModel.userDetails.avatarUrl.isEmpty)
        await #expect(viewModel.userDetails.name == nil)

        mockApiClient.userDetails = UserDetails(
            login: "mike", avatarUrl: "http://google.com", name: "Michael Arianto", followers: 10,
            following: 15, reposUrl: "http://github.com/mike")
        await viewModel.loadUserDetails(userId: 1)

        await #expect(viewModel.userDetails.login == "mike")
        await #expect(viewModel.userDetails.reposUrl == "http://github.com/mike")
        await #expect(viewModel.userDetails.followers == 10)
        await #expect(viewModel.repositories.isEmpty)
        await #expect(viewModel.webViewUrlString == nil)
    }

    @Test func testLoadRepositories() async throws {
        let mockApiClient = MockUserDetailsAPIClient()
        let viewModel = await UserDetailsViewModel(apiClient: mockApiClient)

        await #expect(viewModel.repositories.isEmpty)
        let expectedRepositories: [Repository] = [
            Repository(
                id: 12, name: "GitHubUsers1", description: nil, fork: true, language: nil,
                stargazersCount: 100, htmlUrl: ""),
            Repository(
                id: 13, name: "GitHubUsers2", description: nil, fork: false, language: nil,
                stargazersCount: 100, htmlUrl: ""),
            Repository(
                id: 14, name: "GitHubUsers3", description: nil, fork: false, language: "Ruby",
                stargazersCount: 300, htmlUrl: ""),
        ]
        mockApiClient.userRepositoriesAndLink = (
            expectedRepositories,
            "<https://api.github.com/repositories/1300192/issues?page=4>; rel=\"next\""
        )
        mockApiClient.userDetails = UserDetails(
            login: "mike", avatarUrl: "http://google.com", name: "Michael Arianto", followers: 10,
            following: 15, reposUrl: "http://github.com/mike")
        await viewModel.loadUserDetails(userId: 1)  // to get the repos URL
        await viewModel.loadNextPageOfRepositories()

        await #expect(viewModel.repositories.count == 2, "Not forked only")
        await #expect(viewModel.repositories[0].name == "GitHubUsers2")
        await #expect(viewModel.repositories[0].language == nil)
        await #expect(viewModel.repositories[0].stargazersCount == 100)
        await #expect(viewModel.repositories[1].name == "GitHubUsers3")
        await #expect(viewModel.repositories[1].language == "Ruby")
        await #expect(viewModel.repositories[1].stargazersCount == 300)
        await #expect(
            viewModel.nextPageUrl == "https://api.github.com/repositories/1300192/issues?page=4")

        // add 1 more repo, no next page link
        mockApiClient.userRepositoriesAndLink = (
            [
                Repository(
                    id: 333, name: "GitHubUsers333", description: nil, fork: false, language: nil,
                    stargazersCount: 100, htmlUrl: "")
            ],
            ""
        )
        await viewModel.loadNextPageOfRepositories()
        await #expect(viewModel.nextPageUrl == nil)
        await #expect(viewModel.repositories.count == 3)

        mockApiClient.userRepositoriesAndLink = (
            [
                Repository(
                    id: 345, name: "GitHubUsers345", description: nil, fork: false, language: nil,
                    stargazersCount: 100, htmlUrl: "")
            ],
            ""
        )
        await viewModel.loadNextPageOfRepositories()  // will do nothing, due nextPageUrl nil
        await #expect(viewModel.nextPageUrl == nil)
        await #expect(viewModel.repositories.count == 3)
    }

    @Test func testShouldNotPopulateForkedRepo() async throws {
        let mockApiClient = MockUserDetailsAPIClient()
        let viewModel = await UserDetailsViewModel(apiClient: mockApiClient)

        await #expect(viewModel.repositories.isEmpty)
        let expectedRepositories: [Repository] = [
            Repository(
                id: 12, name: "GitHubUsers1", description: nil, fork: true, language: nil,
                stargazersCount: 100, htmlUrl: ""),
            Repository(
                id: 13, name: "GitHubUsers2", description: nil, fork: true, language: nil,
                stargazersCount: 100, htmlUrl: ""),
            Repository(
                id: 14, name: "GitHubUsers3", description: nil, fork: true, language: "Ruby",
                stargazersCount: 300, htmlUrl: ""),
        ]
        mockApiClient.userRepositoriesAndLink = (expectedRepositories, "randomstring")
        mockApiClient.userDetails = UserDetails(
            login: "mike", avatarUrl: "http://google.com", name: "Michael Arianto", followers: 10,
            following: 15, reposUrl: "http://github.com/mike")
        await viewModel.loadUserDetails(userId: 1)  // to get the repos URL
        await viewModel.loadNextPageOfRepositories()

        await #expect(viewModel.repositories.isEmpty, "All repo forked")
        await #expect(viewModel.nextPageUrl == nil)
    }

    @Test func testGetNextLinkOnly() async throws {
        let mockApiClient = MockUserDetailsAPIClient()
        let viewModel = await UserDetailsViewModel(apiClient: mockApiClient)

        mockApiClient.userRepositoriesAndLink = (
            [],
            "<https://api.github.com/repositories/1300192/issues?page=2>; rel=\"prev\", <https://api.github.com/repositories/1300192/issues?page=4>; rel=\"next\", <https://api.github.com/repositories/1300192/issues?page=515>; rel=\"last\", <https://api.github.com/repositories/1300192/issues?page=1>; rel=\"first\""
        )
        mockApiClient.userDetails = UserDetails(
            login: "mike", avatarUrl: "http://google.com", name: "Michael Arianto", followers: 10,
            following: 15, reposUrl: "http://github.com/mike")
        await viewModel.loadUserDetails(userId: 1)  // to get the repos URL
        await viewModel.loadNextPageOfRepositories()

        await #expect(
            viewModel.nextPageUrl == "https://api.github.com/repositories/1300192/issues?page=4")

        mockApiClient.userRepositoriesAndLink = (
            [],
            "<https://api.github.com/repositories/1300192/issues?page=2>; rel=\"prev\", <https://api.github.com/repositories/1300192/issues?page=515>; rel=\"last\", <https://api.github.com/repositories/1300192/issues?page=1>; rel=\"first\""
        )
        await viewModel.loadUserDetails(userId: 1)  // to get the repos URL
        await viewModel.loadNextPageOfRepositories()

        await #expect(viewModel.nextPageUrl == nil)

        mockApiClient.userRepositoriesAndLink = (
            [], "<https://api.github.com/repositories/1300192/issues?page=2; rel=\"next\""
        )
        await viewModel.loadUserDetails(userId: 1)  // to get the repos URL
        await viewModel.loadNextPageOfRepositories()

        await #expect(viewModel.nextPageUrl == nil, "wrong format, no > character")

        mockApiClient.userRepositoriesAndLink = (
            [], "<https://api.github.com/repositories/1300192/issues?page=2;rel=\"next\""
        )
        await viewModel.loadUserDetails(userId: 1)  // to get the repos URL
        await viewModel.loadNextPageOfRepositories()

        await #expect(viewModel.nextPageUrl == nil, "wrong format, no space before rel keyword")

        mockApiClient.userRepositoriesAndLink = ([], "<anystring>; rel=\"next\"")
        await viewModel.loadUserDetails(userId: 1)  // to get the repos URL
        await viewModel.loadNextPageOfRepositories()

        await #expect(viewModel.nextPageUrl == "anystring", "takes any string inside < >")

        mockApiClient.userRepositoriesAndLink = ([], nil)
        await viewModel.loadUserDetails(userId: 1)  // to get the repos URL
        await viewModel.loadNextPageOfRepositories()

        await #expect(viewModel.nextPageUrl == nil)
    }
}
