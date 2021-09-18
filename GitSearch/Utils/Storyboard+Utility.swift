//
//  Storyboard+Utility.swift
//  Storyboard+Utility
//
//  Created by Valeriy Malishevskyi on 15.09.2021.
//

import UIKit

extension UIStoryboard {
    enum StoryboardType: String {
        case main
        case login

        var filename: String {
            return rawValue.capitalized
        }
    }

    convenience init(type: StoryboardType, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }

    static func initialViewController(for type: StoryboardType) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }

        return initialViewController
    }
}
