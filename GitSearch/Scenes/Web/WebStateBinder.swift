//
//  WebStateBinder.swift
//  WebStateBinder
//
//  Created by Valeriy Malishevskyi on 16.09.2021.
//

import Foundation

final class WebStateBinder: ViewControllerBinder {
    unowned let viewController: WebViewController
    private let driver: WebDriving

    init(viewController: WebViewController,
         driver: WebDriving) {
        self.viewController = viewController
        self.driver = driver
        bind()
    }

    func dispose() { }

    func bindLoaded() {
        viewController.bag.insert(
            viewController.rx.viewWillAppear
                .bind(onNext: unowned(self, in: WebStateBinder.viewWillAppear))
        )
    }

    private func viewWillAppear(_ animated: Bool) {
        viewController.tabBarController?.tabBar.isHidden = true
        viewController.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
