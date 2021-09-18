//
//  LoginActionBinder.swift
//  LoginActionBinder
//
//  Created by Valeriy Malishevskyi on 17.09.2021.
//

import RxSwift

final class LoginActionBinder: ViewControllerBinder {
    unowned let viewController: LoginViewController
    private let driver: LoginDriving

    init(viewController: LoginViewController,
         driver: LoginDriving) {
        self.viewController = viewController
        self.driver = driver

        bind()
    }

    func dispose() { }

    func bindLoaded() {
        let didTapButton = viewController.githubLoginButton.rx.tap

        viewController.bag.insert(
            didTapButton.bind(onNext: driver.openAuth)
        )
    }
}
