//
//  HistoryViewController.swift
//  GitSearch
//
//  Created by Valeriy Malishevskyi on 18.09.2021.
//

import UIKit

class HistoryViewController: DisposeViewController {
    @IBOutlet private(set) var tableView: UITableView!
}

extension HistoryViewController {
    static func loadFromStoryboard() -> Self? {
        let storyboard = UIStoryboard(type: .main)
        return storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as? Self
    }
}

extension HistoryViewController: StaticFactory {
    enum Factory {
        static var `default`: HistoryViewController {
            let vc = HistoryViewController.loadFromStoryboard()!
            let driver = HistoryDriver.Factory.default
            let stateBinder = HistoryStateBinder.Factory
                .default(vc, driver: driver)
            let actionBinder = HistoryActionBinder(viewController: vc, driver: driver)
            let navigationBinder = NavigationPushBinder<HistoryItem, HistoryViewController>.Factory
                .push(viewController: vc,
                      driver: driver.didSelect,
                      factory: detailViewControllerFactory)
            vc.bag.insert(
                stateBinder,
                actionBinder,
                navigationBinder
            )
            return vc
        }

        private static func detailViewControllerFactory(_ item: HistoryItem) -> UIViewController {
            let url = URL(string: item.repoULRSting)!
            let vc = WebViewController.Factory.default(url: url)

            return vc
        }
    }
}
