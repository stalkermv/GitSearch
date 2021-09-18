//
//  DisposeViewController.swift
//  DisposeViewController
//
//  Created by Valeriy Malishevskyi on 15.09.2021.
//

import UIKit
import RxSwift

class DisposeViewController: UIViewController, DisposeContainer {
    let bag = DisposeBag()

    static var defaultStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }

    var statusBarStyle = defaultStatusBarStyle {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    var statusBarUpdateAnimation: UIStatusBarAnimation = .none {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    var isStatusBarHidden: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    // MARK: - Override

    override var prefersStatusBarHidden: Bool {
        isStatusBarHidden
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        statusBarUpdateAnimation
    }
}
