//
//  UIColor+Extension.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/28.
//

import UIKit

extension UIColor {
    static var tabButtonColor: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return .white
            } else {
                return .black
            }
        }
    }
    static var tabBottomBarColor: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return .white
            } else {
                return .black
            }
        }
    }
}
