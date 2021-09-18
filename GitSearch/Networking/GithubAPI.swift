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
    private var nextCursor: Cursor?

    init(httpClient: HTTPClientProvider) {
        self.httpClient = httpClient
    }

    func searchRepositories(forQuery query: String) -> Observable<[Repository]> {
        multiThreadingWrapper(query: query)
    }

    func loadNextResults() -> Observable<[Repository]> {
        guard let nextCursor = nextCursor else {
            return Observable.just([])
        }

        return multiThreadingWrapper(query: nextCursor.query, page: nextCursor.page)
    }

    private func multiThreadingWrapper(query: String, page: Int = 1) -> Observable<[Repository]> {
        let internalPagingNextPage = page * 2
        nextCursor = Cursor(query: query, page: page + 1)
        
        return Observable.zip(
            searchRepositories(for: query, page: internalPagingNextPage - 1),
            searchRepositories(for: query, page: internalPagingNextPage),
            resultSelector: { $0 + $1 }
        )
    }

    private func searchRepositories(
        for query: String,
        page: Int = 1
    ) -> Observable<[Repository]> {
        httpClient.get(
            url: Constants.baseURL +
            Constants.repositorySearchEndpoint +
            "?q=\(query)&sort=stars&page=\(page)&per_page=15"
        )
        .unwrap()
        .decode(type: GithubRepositorySearchResponse.self, decoder: JSONDecoder())
        .map(\.items)
    }

    private struct Cursor {
        let query: String
        let page: Int
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
