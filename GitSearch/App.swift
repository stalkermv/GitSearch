//
//  App.swift
//  App
//
//  Created by Valeriy Malishevskyi on 15.09.2021.
//

import UIKit
import OAuth2
import RxSwift

final class App {
    private let bag = DisposeBag()

    weak private var service: AuthService?
    weak private var window: UIWindow?

    init(with window: UIWindow, service: AuthService) {
        self.window = window
        self.service = service
        bind()
    }

    private func bind() {
        service?.isAuthorized
            .drive(onNext: unowned(self, in: App.applyView))
            .disposed(by: bag)
    }

    private func applyView(authStatus isAuthorized: Bool) {
        if isAuthorized {
            UIApplication.setRootView(
                makeTabView(),
                for: window,
                options: UIApplication.loginAnimation
            )
        } else {
            UIApplication.setRootView(
                makeLoginScreen(),
                for: window,
                options: UIApplication.logoutAnimation
            )
        }
    }

    private func makeTabView() -> UITabBarController {
        let searchNavigationController = UINavigationController(rootViewController: SearchViewController.Factory.default)
        let historyNavigationController = UINavigationController(rootViewController: HistoryViewController.Factory.default)

        let tabBarController = UITabBarController()

        historyNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        searchNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        tabBarController.viewControllers = [
            searchNavigationController,
            historyNavigationController
        ]

        return tabBarController
    }

    private func makeLoginScreen() -> LoginViewController {
        LoginViewController.Factory.default
    }

}

extension App: StaticFactory {
    enum Factory {
        static func `default`(with window: UIWindow, service: AuthService = AppDelegate.shared.auth) -> App {
            let app = App(with: window, service: service)
            return app
        }
    }
}
