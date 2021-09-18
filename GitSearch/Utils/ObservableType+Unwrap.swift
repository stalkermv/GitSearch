//
//  ObservableType+Unwrap.swift
//  ObservableType+Unwrap
//
//  Created by Valeriy Malishevskyi on 16.09.2021.
//

import RxSwift

extension ObservableType {

    /**
     Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.

     - returns: An observable sequence of non-optional elements
     */

    public func unwrap<Result>() -> Observable<Result> where Element == Result? {
        return self.compactMap { $0 }
    }
}
