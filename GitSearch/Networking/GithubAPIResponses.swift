//
//  GithubAPIResponses.swift
//  GithubAPIResponses
//
//  Created by Valeriy Malishevskyi on 16.09.2021.
//

import Foundation

struct GithubRepositorySearchResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
