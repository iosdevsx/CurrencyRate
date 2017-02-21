//
//  ViewExtensions.swift
//  CurrencyRate
//
//  Created by Юрий Логинов on 20.02.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public class func instantiateFromNib<T: UIView>(viewType: T.Type) -> T {
        return Bundle.main.loadNibNamed(String(describing: viewType), owner: self, options: nil)?.first as! T
    }
    
    public class func instantiateFromNib() -> Self {
        return instantiateFromNib(viewType: self)
    }
}
