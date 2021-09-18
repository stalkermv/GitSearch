//
//  HistoryDriver.swift
//  GitSearch
//
//  Created by Valeriy Malishevskyi on 18.09.2021.
//

import Foundation
import RxSwift
import RxCocoa

struct HistoryItem: Codable, Equatable {
    let repoName: String
    let repoULRSting: String
    let openTime: Date

    static func ==(lhs: HistoryItem, rhs: HistoryItem) -> Bool {
        return lhs.repoName == rhs.repoName &&
        lhs.repoULRSting == rhs.repoULRSting
    }
}

extension HistoryItem {
    init(from searchResult: SearchResultItem, openTime: Date = Date()) {
        self.repoName = searchResult.title
        self.repoULRSting = searchResult.urlString
        self.openTime = openTime
    }
}

protocol HistoryState {
    var data: Driver<[HistoryItem]> { get }
    var didSelect: Driver<HistoryItem> { get }
}

protocol HistoryAction {
    func select(_ model: HistoryItem)
}

protocol HistoryDriving: AnyObject, HistoryState, HistoryAction, DisposeContainer { }

final class HistoryDriver: HistoryDriving {

    let bag = DisposeBag()
    private let dataRelay = BehaviorRelay<[HistoryItem]>(value: [])
    private let didSelectRelay = BehaviorRelay<HistoryItem?>(value: nil)
    private let storage: HistoryStorageProvider

    var data: Driver<[HistoryItem]> { dataRelay.asDriver() }
    var didSelect: Driver<HistoryItem> { didSelectRelay.unwrap().asDriver() }

    init(storage: HistoryStorageProvider) {
        self.storage = storage
        bind()
    }

    func select(_ model: HistoryItem) {
        didSelectRelay.accept(model)
    }

    private func bind() {
        storage.getAll()
            .bind(to: dataRelay)
            .disposed(by: bag)
    }
}

extension HistoryDriver: StaticFactory {
    enum Factory {
        static let `default`: HistoryDriving = HistoryDriver(storage: HistoryStorage.Factory.default)
    }
}
