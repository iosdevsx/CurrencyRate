//
//  NavigationBarExtension.swift
//  CurrencyRate
//
//  Created by Юрий Логинов on 20.02.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    public func setBaseStyle() {
        self.navigationBar.backgroundColor = UIColor.charcoal()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationBar.shadowImage = UIImage.init(named: "navigationBarDivider")
        self.navigationBar.barStyle = .black
    }
}
