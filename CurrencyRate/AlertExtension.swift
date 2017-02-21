//
//  AlertExtension.swift
//  CurrencyRate
//
//  Created by Юрий Логинов on 21.02.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static func alert(title:String, message: String) -> UIAlertController {
        let ac = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .cancel) { (action) in
            ac.dismiss(animated: true, completion: nil)
        }
        ac.addAction(action)
        
        return ac
    }
}
