//
//  ViewControllerBinder.swift
//  ViewControllerBinder
//
//  Created by Valeriy Malishevskyi on 15.09.2021.
//

import UIKit
import RxSwift

protocol ViewControllerBinder: Disposable {
    associatedtype DisposeViewControllerContainer: UIViewController, DisposeContainer

    var viewController: DisposeViewControllerContainer { get }

    func bindLoaded()
}

extension ViewControllerBinder where Self: AnyObject {
    func bind() {
        viewController.rx.viewDidLoad
            .subscribe(onNext: unowned(self, in: Self.bindLoaded))
            .disposed(by: viewController.bag)
    }
}
