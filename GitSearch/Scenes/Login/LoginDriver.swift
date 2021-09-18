//
//  LoginDriver.swift
//  LoginDriver
//
//  Created by Valeriy Malishevskyi on 17.09.2021.
//

import RxSwift
import RxCocoa

protocol LoginState {
    var didTapOpen: Driver<Void> { get }
}

protocol LoginAction {
    func openAuth()
    
}

protocol LoginDriving: AnyObject, LoginState, LoginAction, DisposeContainer { }

final class LoginDriver: LoginDriving {
    let bag = DisposeBag()
    private let openRelay = PublishRelay<Void>()

    var didTapOpen: Driver<Void> { openRelay.asDriver() }

    func openAuth() {
        openRelay.accept(())
    }
}

extension LoginDriver: StaticFactory {
    enum Factory {
        static var `default`: LoginDriving { LoginDriver() }
    }
}
