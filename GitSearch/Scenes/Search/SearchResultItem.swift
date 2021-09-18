//
//  SearchResultItem.swift
//  SearchResultItem
//
//  Created by Valeriy Malishevskyi on 15.09.2021.
//

import Foundation

struct SearchResultItem: Equatable {
    let title: String
    let stars: Int
    let urlString: String
    var isWatched: Bool
}

extension SearchResultItem {
    init(repository: Repository) {
        self.title = repository.name
        self.stars = repository.stargazersCount
        self.urlString = repository.htmlURL
        self.isWatched = false
    }
}
