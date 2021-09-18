//
//  UIApplication+SetRootView.swift
//  GitSearch
//
//  Created by Valeriy Malishevskyi on 18.09.2021.
//

import UIKit

extension UIApplication {
    
    static var loginAnimation: UIView.AnimationOptions = .transitionFlipFromRight
    static var logoutAnimation: UIView.AnimationOptions = .transitionCrossDissolve

    public static func setRootView(
        _ viewController: UIViewController,
        for window: UIWindow?,
        options: UIView.AnimationOptions = .transitionFlipFromRight,
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        completion: (() -> Void)? = nil
    ) {
        guard animated else {
            window?.rootViewController = viewController
            return
        }

        UIView.transition(with: window!, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window?.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in completion?() }
    }
}
