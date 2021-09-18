//
//  HistoryActionBinder.swift
//  GitSearch
//
//  Created by Valeriy Malishevskyi on 18.09.2021.
//

import Foundation
import RxSwift

final class HistoryActionBinder: ViewControllerBinder {
    unowned let viewController: HistoryViewController
    private let driver: HistoryDriving

    init(viewController: HistoryViewController,
         driver: HistoryDriving) {
        self.viewController = viewController
        self.driver = driver

        bind()
    }

    func dispose() { }

    func bindLoaded() {
        let didSelectItem = viewController.tableView.rx.modelSelected(HistoryItem.self)

        viewController.bag.insert(
            didSelectItem
                .bind(onNext: driver.select)
        )
    }


}

