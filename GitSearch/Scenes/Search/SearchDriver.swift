//
//  SearchDriver.swift
//  SearchDriver
//
//  Created by Valeriy Malishevskyi on 15.09.2021.
//

import RxSwift
import RxCocoa

protocol SearchState {
    var data: Driver<[SearchResultItem]> { get }
    var didSelect: Driver<SearchResultItem> { get }
}

protocol SearchAction {
    func select(_ model: SearchResultItem)
    func search(_ query: String)
    func loadMoreResults()
}

protocol SearchDriving: AnyObject, SearchState, SearchAction, DisposeContainer { }

final class SearchDriver: SearchDriving {

    let bag = DisposeBag()
    private let dataRelay = BehaviorRelay<[SearchResultItem]>(value: [])
    private let didSelectRelay = BehaviorRelay<SearchResultItem?>(value: nil)
    private let queryRelay = PublishRelay<String>()
    private let loadNextRelay = PublishRelay<Void>()

    private let api: GithubAPIProvider
    private let storage: HistoryStorageProvider!

    var data: Driver<[SearchResultItem]> { dataRelay.asDriver() }
    var didSelect: Driver<SearchResultItem> { didSelectRelay.unwrap().asDriver() }

    init(api: GithubAPIProvider, storage: HistoryStorageProvider) {
        self.api = api
        self.storage = storage
        bind()
    }

    func search(_ query: String) {
        queryRelay.accept(query)
    }

    func loadMoreResults() {
        loadNextRelay.accept(())
    }

    func select(_ model: SearchResultItem) {
        didSelectRelay.accept(model)
        storage.collect(item: HistoryItem.init(from: model))
    }

    private func toggleWatchState(_ models: [SearchResultItem]) -> Observable<[SearchResultItem]> {
        let urls = models.map(\.urlString)
        return storage.getEntires(urlStrings: urls)
            .map { history in
                var models = models
                history.forEach { historyItem in
                    if let index = models.firstIndex(where: { $0.urlString == historyItem.repoULRSting } ) {
                        models[index].isWatched = true
                    }
                }
                return models
            }
    }

    private func append(new data: [SearchResultItem]) {
        let data = dataRelay.value + data
        dataRelay.accept(data)
    }

    private func bind() {
        queryRelay
            .filter({ $0.count > 3 }, or: unowned(self, in: SearchDriver.clearData))
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap(api.searchRepositories)
            .mapMany(SearchResultItem.init)
            .flatMap(toggleWatchState)
            .bind(onNext: dataRelay.accept)
            .disposed(by: bag)

        loadNextRelay
            .flatMapFirst(api.loadNextResults)
            .mapMany(SearchResultItem.init)
            .flatMap(toggleWatchState)
            .bind(onNext: unowned(self, in: SearchDriver.append))
            .disposed(by: bag)
    }

    private func clearData() {
        dataRelay.accept([])
    }
}

extension SearchDriver: StaticFactory {
    enum Factory {
        static var `default`: SearchDriving {
            let storage = HistoryStorage.Factory.default
            return SearchDriver(api: GithubAPI.Factory.default, storage: storage)
        }
    }
}
