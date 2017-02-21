//
//  CurrencyModel.swift
//  CurrencyRate
//
//  Created by Юрий Логинов on 21.02.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

import Foundation

class CurrencyModel {
    var currency: String?
    var rate: NSNumber?
    
    init(currency: String, rate: NSNumber) {
        self.currency = currency
        self.rate = rate
    }
}
