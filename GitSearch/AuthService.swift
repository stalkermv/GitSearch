//
//  AuthService.swift
//  GitSearch
//
//  Created by Valeriy Malishevskyi on 18.09.2021.
//

import Foundation
import OAuth2
import RxSwift
import RxCocoa

final class AuthService {
    private var oauth2: OAuth2CodeGrant
    private let isAuthorizedRelay = BehaviorRelay<Bool?>(value: nil)

    var isAuthorized: Driver<Bool> { isAuthorizedRelay.unwrap().asDriver() }

    var session: URLSession {
        oauth2.session
    }

    init() {
        oauth2 = OAuth2CodeGrant(settings: [
            "client_id": "e264685d6b87db079f1e", // Yes it`s real key and works
            "client_secret": "6b1abf59d639e6c3cd4fbed2a74fec8a9cfb3c02",
            "authorize_uri": "https://github.com/login/oauth/authorize",
            "token_uri": "https://github.com/login/oauth/access_token",
            "scope": "user repo:status",
            "redirect_uris": ["gitsearch://oauth/callback"],
            "secret_in_body": true,
        ])

        configure()
    }

    func setAuthorizeContext(_ viewController: AnyObject) {
        oauth2.authConfig.authorizeContext = viewController
    }

    func performAuthorization() {
        oauth2.authorize(params: nil, callback: { _,_ in })
    }

    func logout() {
        oauth2.abortAuthorization()
        oauth2.forgetTokens()
        isAuthorizedRelay.accept(false)
    }

    func handleRedirectURL(url: URL) {
        oauth2.handleRedirectURL(url)
    }

    private func configure() {
        oauth2.authConfig.authorizeEmbedded = true
        oauth2.authConfig.ui.useAuthenticationSession = true
        oauth2.authConfig.authorizeEmbeddedAutoDismiss = false
        oauth2.afterAuthorizeOrFail = weak(self, in: AuthService.afterAuthorizeOrFail)

        let authorized = oauth2.hasUnexpiredAccessToken()
        isAuthorizedRelay.accept(authorized)
    }

    private func afterAuthorizeOrFail(_ params: OAuth2JSON?, _ error: OAuth2Error?) {
        // Not interested in credentials. Just set flag that user is authorized
        if params != nil { isAuthorizedRelay.accept(true) }
    }
}
