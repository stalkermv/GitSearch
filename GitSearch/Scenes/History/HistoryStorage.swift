//
//  HistoryStorage.swift
//  GitSearch
//
//  Created by Valeriy Malishevskyi on 18.09.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol HistoryStorageProvider {
    func getAll() -> Observable<[HistoryItem]>
    func collect(item: HistoryItem)
    func getEntires(urlStrings: [String]) -> Observable<[HistoryItem]>
}

final class HistoryStorage: HistoryStorageProvider {
    private let bag = DisposeBag()
    private let storageKey: String
    private let storageRelay = BehaviorRelay<[HistoryItem]>(value: [])

    private var storage: [HistoryItem] = [] {
        didSet {
            storageRelay.accept(storage)
            saveState()
        }
    }

    func getAll() -> Observable<[HistoryItem]> {
        storageRelay.asObservable()
    }

    func getEntires(urlStrings: [String]) -> Observable<[HistoryItem]> {
        storageRelay.asObservable()
            .map { storage -> [HistoryItem] in
                let result = storage.filter { urlStrings.contains($0.repoULRSting) }
                return result
            }
    }

    func collect(item: HistoryItem) {
        if let index = storage.firstIndex(of: item) {
            storage[index] = item
            return
        }

        storage.append(item)

        guard storage.count > 20 else { return }

        if let oldRecord = storage.min(by: { $0.openTime < $1.openTime }),
           let index = storage.firstIndex(of: oldRecord) {
            storage.remove(at: index)
        }
    }

    private func bind() {
        // Use UserDefaults as storage backend just for test
        UserDefaults.standard.rx
            .observe(Data.self, storageKey)
            .unwrap()
            .map { try? JSONDecoder().decode([HistoryItem].self, from: $0) }
            .unwrap()
            .bind(onNext: unowned(self, in: HistoryStorage.assign))
            .disposed(by: bag)
    }

    init(storageKey: String) {
        self.storageKey = storageKey
        bind()
    }

    private func assign(value: [HistoryItem]) {
        storage = value
    }

    private func saveState() {
        if let data = try? JSONEncoder().encode(storage) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}

extension HistoryStorage: StaticFactory {
    enum Factory {
        static let `default`: HistoryStorageProvider = HistoryStorage(storageKey: "history")
    }
}
