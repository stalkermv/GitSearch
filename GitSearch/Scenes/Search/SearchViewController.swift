//
//  SearchViewController.swift
//  GitSearch
//
//  Created by Valeriy Malishevskyi on 14.09.2021.
//

import UIKit
import SafariServices

class SearchViewController: DisposeViewController {
    @IBOutlet private(set) var tableView: UITableView!
    @IBOutlet private(set) var searchTextField: UITextField!
}

extension SearchViewController: StaticFactory {
    enum Factory {
        static var `default`: SearchViewController {
            let vc = SearchViewController.loadFromStoryboard()!
            let driver = SearchDriver.Factory.default
            let stateBinder = SearchStateBinder.Factory
                .default(vc, driver: driver)
            let actionBinder = SearchActionBinder(viewController: vc, driver: driver)
            let navigationBinder = NavigationPushBinder<SearchResultItem, SearchViewController>.Factory
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

        private static func detailViewControllerFactory(_ item: SearchResultItem) -> UIViewController {
            let url = URL(string: item.urlString)!
            let vc = WebViewController.Factory.default(url: url)
            
            return vc
        }
    }

    // Used by our scene delegate to return an instance of this class from our storyboard.
    static func loadFromStoryboard() -> Self? {
        let storyboard = UIStoryboard(type: .main)
        return storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? Self
    }
}

extension SearchViewController {
    static let startLoadingOffset: CGFloat = 20.0
    static func isNearTheBottomEdge(contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
        return contentOffset.y + tableView.frame.size.height + Self.startLoadingOffset > tableView.contentSize.height
    }
}
