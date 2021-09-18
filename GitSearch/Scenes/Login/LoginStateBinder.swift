//
//  LoginStateBinder.swift
//  LoginStateBinder
//
//  Created by Valeriy Malishevskyi on 17.09.2021.
//

import RxSwift
import RxCocoa
import OAuth2

final class LoginStateBinder: ViewControllerBinder {
    unowned let viewController: LoginViewController
    private let driver: LoginDriving

    init(viewController: LoginViewController, driver: LoginDriving) {
        self.viewController = viewController
        self.driver = driver
        bind()
    }

    func dispose() { }

    func bindLoaded() {
        driver.didTapOpen
            .drive(onNext: unowned(self, in: LoginStateBinder.performLogin))
            .disposed(by: viewController.bag)

        viewController.rx.viewWillAppear
            .bind(onNext: unowned(self, in: LoginStateBinder.viewWillAppear))
            .disposed(by: viewController.bag)
    }

    private func viewWillAppear(_ animated: Bool) {
        viewController.navigationController?.setNavigationBarHidden(true, animated: animated)
        AppDelegate.shared.auth.setAuthorizeContext(viewController)
    }

    private func performLogin()  {
        AppDelegate.shared.auth.performAuthorization()
    }
}

extension LoginStateBinder: StaticFactory {
    enum Factory {
        static func `default`(_ viewController: LoginViewController,
                              driver: LoginDriving) -> LoginStateBinder {
            LoginStateBinder(viewController: viewController,
                              driver: driver)
        }
    }
}
