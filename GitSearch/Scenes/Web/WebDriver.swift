//
//  WebDriver.swift
//  WebDriver
//
//  Created by Valeriy Malishevskyi on 16.09.2021.
//

import Foundation
import RxCocoa

protocol WebState {
    var didClose: Driver<Void> { get }
}

protocol WebAction {
    func close()
}

protocol WebDriving: AnyObject, WebState, WebAction { }

class WebDriver: WebDriving {
    private let closeRelay = PublishRelay<Void>()

    var didClose: Driver<Void> { closeRelay.asDriver() }

    func close() {
        closeRelay.accept(())
    }

}

extension WebDriver: StaticFactory {
    enum Factory {
        static var `default`: WebDriving {
            WebDriver()
        }
    }
}
