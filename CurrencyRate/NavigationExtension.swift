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
        self.backgroundColor = UIColor(red: 58.0 / 255.0, green: 59.0 / 255.0, blue: 65.0 / 255.0, alpha: 1)
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.shadowImage = UIImage.init(named: "navigationBarDivider")
    }
}
