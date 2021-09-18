//
//  WebActionBinder.swift
//  WebActionBinder
//
//  Created by Valeriy Malishevskyi on 16.09.2021.
//

import Foundation

final class WebActionBinder: ViewControllerBinder {
    unowned let viewController: WebViewController
    private let driver: WebDriving

    init(viewController: WebViewController, driver: WebDriving) {
        self.viewController = viewController
        self.driver = driver
        bind()
    }

    func dispose() { }

    func bindLoaded() {
        viewController.bag.insert(
            viewController.rx.didFinish.bind(onNext: driver.close)
        )
    }

}
