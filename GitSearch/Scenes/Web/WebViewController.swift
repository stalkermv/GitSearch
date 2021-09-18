//
//  WebViewController.swift
//  WebViewController
//
//  Created by Valeriy Malishevskyi on 16.09.2021.
//

import UIKit
import RxSwift
import SafariServices

class WebViewController: SFSafariViewController, DisposeContainer {
    let bag = DisposeBag()
}

extension WebViewController {
    enum Factory {
        static func`default`(url: URL) -> WebViewController {
            let vc = WebViewController(url: url)
            let driver = WebDriver.Factory.default
            let actionBinder = WebActionBinder(viewController: vc, driver: driver)
            let stateBinder = WebStateBinder(viewController: vc, driver: driver)
            let navigationBinder = NavigationPopBinder<WebViewController>.Factory
                .pop(viewController: vc, driver: driver.didClose)
            vc.bag.insert(
                stateBinder,
                actionBinder,
                navigationBinder
            )
            return vc
        }
    }
}

// MARK: -

import RxCocoa

extension SFSafariViewController: HasDelegate {
    public typealias Delegate = SFSafariViewControllerDelegate
}

class SFSafariViewControllerDelegateProxy: DelegateProxy<SFSafariViewController, SFSafariViewControllerDelegate>, DelegateProxyType, SFSafariViewControllerDelegate {

    init(parentObject: SFSafariViewController) {
        super.init(parentObject: parentObject, delegateProxy: SFSafariViewControllerDelegateProxy.self)
    }

    static func currentDelegate(for object: SFSafariViewController) -> SFSafariViewControllerDelegate? {
        object.delegate
    }

    static func setCurrentDelegate(_ delegate: SFSafariViewControllerDelegate?, to object: SFSafariViewController) {
        object.delegate = delegate
    }


    public static func registerKnownImplementations() {
        self.register { SFSafariViewControllerDelegateProxy(parentObject: $0) }
    }
}

extension Reactive where Base: SFSafariViewController {
    var delegate: SFSafariViewControllerDelegateProxy {
        return SFSafariViewControllerDelegateProxy.proxy(for: base)
    }

    var didCompleteInitialLoad: ControlEvent<Bool> {
        let source = delegate.methodInvoked(#selector(SFSafariViewControllerDelegate.safariViewController(_:didCompleteInitialLoad:)))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    var didFinish: ControlEvent<Void> {
        let source = delegate.methodInvoked(#selector(SFSafariViewControllerDelegate.safariViewControllerDidFinish(_:)))
            .map { _ in }
        return ControlEvent(events: source)
    }

}
