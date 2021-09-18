//
//  SearchActionBinder.swift
//  SearchActionBinder
//
//  Created by Valeriy Malishevskyi on 15.09.2021.
//

import Foundation
import RxSwift

final class SearchActionBinder: ViewControllerBinder {
    unowned let viewController: SearchViewController
    private let driver: SearchDriving

    init(viewController: SearchViewController,
         driver: SearchDriving) {
        self.viewController = viewController
        self.driver = driver

        bind()
    }

    func dispose() { }

    func bindLoaded() {
        let query = viewController.searchTextField.rx.text.orEmpty
        let didSelectItem = viewController.tableView.rx.modelSelected(SearchResultItem.self)

        let loadNextPage = viewController.tableView.rx.contentOffset
            .skip(1)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { SearchViewController.isNearTheBottomEdge(contentOffset: $0, self.viewController.tableView) }
            .flatMap { $0 ? Observable.just(()) : Observable.empty() }

        viewController.bag.insert(
            query
                .bind(onNext: driver.search),
            didSelectItem
                .bind(onNext: driver.select),
            loadNextPage
                .bind(onNext: driver.loadMoreResults)
        )
    }
}

