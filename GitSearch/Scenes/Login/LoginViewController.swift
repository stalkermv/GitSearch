//
//  LoginViewController.swift
//  LoginViewController
//
//  Created by Valeriy Malishevskyi on 17.09.2021.
//

import UIKit

class LoginViewController: DisposeViewController {
    @IBOutlet weak var githubLoginButton: UIButton!
}

extension LoginViewController {
    static func loadFromStoryboard() -> Self? {
        let storyboard = UIStoryboard(type: .main)
        return storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? Self
    }
}

extension LoginViewController: StaticFactory {
    enum Factory {
        static var `default`: LoginViewController {
            let vc = LoginViewController.loadFromStoryboard()!
            let driver = LoginDriver.Factory.default
            let stateBinder = LoginStateBinder.Factory.default(vc, driver: driver)
            let actionBinder = LoginActionBinder(viewController: vc, driver: driver)

            vc.bag.insert(
                stateBinder,
                actionBinder
            )
            
            return vc
        }
    }

}
