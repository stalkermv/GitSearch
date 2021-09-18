//
//  HTTPClient.swift
//  HTTPClient
//
//  Created by Valeriy Malishevskyi on 16.09.2021.
//

import Foundation
import RxSwift
import OAuth2

protocol HTTPClientProvider {
    func get(url: String) -> Observable<Data?>
    func post(url: String, params: [String: Any]) -> Observable<Data?>
}

final class HTTPClient: HTTPClientProvider {
    let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func get(url: String) -> Observable<Data?> {
        guard let url = URL(string: url) else { return Observable.empty() }
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

        return URLSession.shared.rx.data(request: request)
            .map { Optional.init($0) }
            .catchAndReturn(nil)
    }

    func post(url: String, params: [String: Any]) -> Observable<Data?> {
        guard let url = URL(string: url) else { return Observable.empty() }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        request.httpBody = jsonData

        return URLSession.shared.rx.data(request: request)
            .map { Optional.init($0) }
            .catchAndReturn(nil)
    }
}
