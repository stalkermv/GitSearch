//
//  GithubAPI.swift
//  GithubAPI
//
//  Created by Valeriy Malishevskyi on 15.09.2021.
//

import Foundation
import RxSwift
import OAuth2
import UIKit

protocol GithubAPIProvider {
    func searchRepositories(forQuery query: String) -> Observable<[Repository]>
    func loadNextResults() -> Observable<[Repository]>
}

final class GithubAPI: GithubAPIProvider {

    private struct Constants {
        static let baseURL = "https://api.github.com"
        static let repositorySearchEndpoint = "/search/repositories"
    }

    private let httpClient: HTTPClientProvider
    private var nextCursor: (() -> Observable<[Repository]>)?

    init(httpClient: HTTPClientProvider) {
        self.httpClient = httpClient
    }

    func searchRepositories(forQuery query: String) -> Observable<[Repository]> {
        searchRepositories(for: query, page: 1)
    }

    func loadNextResults() -> Observable<[Repository]> {
        guard let nextCursor = nextCursor?() else {
            return Observable.just([])
        }

        return nextCursor
    }

    private func searchRepositories(
        for query: String,
        page: Int = 0
    ) -> Observable<[Repository]> {
        nextCursor = { self.searchRepositories(for: query, page: page + 1) }

        return httpClient.get(
            url: Constants.baseURL +
            Constants.repositorySearchEndpoint +
            "?q=\(query)&sort=stars&page=\(page)"
        )
        .unwrap()
        .decode(type: GithubRepositorySearchResponse.self, decoder: JSONDecoder())
        .map(\.items)
    }
}

extension GithubAPI: StaticFactory {
    enum Factory {
        static let `default`: GithubAPIProvider = {
            let session = AppDelegate.shared.auth.session
            let client = HTTPClient(session: session)
            return GithubAPI(httpClient: client)
        }()
    }
}
