//
//  ObservableType+Extensions.swift
//  GitSearch
//
//  Created by Valeriy Malishevskyi on 18.09.2021.
//

import RxSwift

extension ObservableType {
    public func filter(_ predicate: @escaping (Element) throws -> Bool, or callback: @escaping () -> Void) -> Observable<Element> {
        return flatMap { element -> Observable<Element> in
            guard try predicate(element) else {
                callback()
                return Observable.never()
            }
            return Observable.just(element)
        }
    }
}
