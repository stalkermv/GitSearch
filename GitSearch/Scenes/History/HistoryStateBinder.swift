//
//  HistoryStateBinder.swift
//  GitSearch
//
//  Created by Valeriy Malishevskyi on 18.09.2021.
//

import UIKit
import RxCocoa
import RxSwift

final class HistoryStateBinder: ViewControllerBinder {
    typealias Items = [HistoryItem]


    struct Section: SectionModelType {
        let items: Items

        init(items: Items) {
            self.items = items
        }

        init(original: Self, items: Items) {
            self.items = items
        }
    }

    unowned let viewController: HistoryViewController
    private let driver: HistoryDriving
    private let dataSource: RxTableViewSectionedReloadDataSource<Section>

    init(viewController: HistoryViewController, driver: HistoryDriving, dataSource: RxTableViewSectionedReloadDataSource<Section>) {
        self.viewController = viewController
        self.driver = driver
        self.dataSource = dataSource
        bind()
    }

    func dispose() { }

    func bindLoaded() {
        HistoryTableViewCell.register(with: viewController.tableView)

        let sections = driver.data
            .map { $0.sorted(by: { $0.openTime > $1.openTime }) }
            .map(Section.init).map({ [$0] })

        viewController.bag.insert(
            viewController.rx.viewWillAppear
                .bind(onNext: unowned(self, in: HistoryStateBinder.viewWillAppear)),
            sections.drive(viewController.tableView.rx.items(dataSource: dataSource))
        )
    }


    private func viewWillAppear(_ animated: Bool) {
        viewController.title = "History"
        viewController.navigationController?.setNavigationBarHidden(false, animated: animated)
        viewController.tabBarController?.tabBar.isHidden = false
    }
}

extension HistoryStateBinder: StaticFactory {
    enum Factory {
        static func `default`(_ viewController: HistoryViewController,
                              driver: HistoryDriving) -> HistoryStateBinder {
            let dataSource = RxTableViewSectionedReloadDataSource<Section>(configureCell: cellFactory)
            return HistoryStateBinder(viewController: viewController,
                                     driver: driver,
                                     dataSource: dataSource)
        }
    }

    private static func cellFactory(_: TableViewSectionedDataSource<Section>,
                                    tableView: UITableView,
                                    indexPath: IndexPath,
                                    item: Section.Item) -> UITableViewCell {
        let cell = HistoryTableViewCell.dequeueReusableCell(from: tableView, for: indexPath)
        cell.configure(withSearchResultItem: item)
        return cell
    }
}
