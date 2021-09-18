//
//  SearchStateBinder.swift
//  SearchStateBinder
//
//  Created by Valeriy Malishevskyi on 15.09.2021.
//

import UIKit
import RxCocoa
import RxSwift

final class SearchStateBinder: ViewControllerBinder {
    typealias Items = [SearchResultItem]


    struct Section: SectionModelType {
        let items: Items

        init(items: Items) {
            self.items = items
        }

        init(original: Self, items: Items) {
            self.items = items
        }
    }

    unowned let viewController: SearchViewController
    private let driver: SearchDriving
    private let dataSource: RxTableViewSectionedReloadDataSource<Section>

    init(viewController: SearchViewController, driver: SearchDriving, dataSource: RxTableViewSectionedReloadDataSource<Section>) {
        self.viewController = viewController
        self.driver = driver
        self.dataSource = dataSource
        bind()
    }

    func dispose() { }

    func bindLoaded() {
        RepositorySearchTableViewCell.register(with: viewController.tableView)
        let sections = driver.data
            .map { $0.sorted(by: { $0.stars > $1.stars }) }
            .map(Section.init).map({ [$0] })

        viewController.bag.insert(
            viewController.rx.viewWillAppear
                .bind(onNext: unowned(self, in: SearchStateBinder.viewWillAppear)),
            driver.data
                .drive(onNext: unowned(self, in: SearchStateBinder.configure)),
            sections.drive(viewController.tableView.rx.items(dataSource: dataSource))
        )
    }

    private func configure(_ data: Items) {
//        viewController.headerView.configure(with: data)
//        viewController.tipsView.configure(with: data)
//        if let url = data.posterUrl {
//            Nuke.loadImage(with: URL(string: url)!, into: viewController.posterImageView)
//        }
    }

    private func viewWillAppear(_ animated: Bool) {
        viewController.tabBarController?.tabBar.isHidden = false
        viewController.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension SearchStateBinder: StaticFactory {
    enum Factory {
        static func `default`(_ viewController: SearchViewController,
                              driver: SearchDriving) -> SearchStateBinder {
            let dataSource = RxTableViewSectionedReloadDataSource<Section>(configureCell: cellFactory)
            return SearchStateBinder(viewController: viewController,
                                     driver: driver,
                                     dataSource: dataSource)
        }
    }

    private static func cellFactory(_: TableViewSectionedDataSource<Section>,
                                    tableView: UITableView,
                                    indexPath: IndexPath,
                                    item: Section.Item) -> UITableViewCell {

        let cell = RepositorySearchTableViewCell.dequeueReusableCell(from: tableView, for: indexPath)
        cell.configure(withSearchResultItem: item)
        return cell
    }
}
