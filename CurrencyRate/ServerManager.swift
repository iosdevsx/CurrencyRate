//
//  ServerManager.swift
//  CurrencyRate
//
//  Created by Юрий Логинов on 21.02.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

import Foundation
import UIKit

class ServerManager {
    
    static let shared = ServerManager()
    
    func requestCurrencyList(baseCurrency: String, parseHandler: @escaping (Array<CurrencyModel>, Error?) -> Void) {
        let url = URL(string: Constants.latestCurrency+baseCurrency)
        
        let dataTask = URLSession.shared.dataTask(with: url!) { (dataRecieved, response, error) in
            var result: Array<CurrencyModel> = []
            
            guard dataRecieved != nil else {
                parseHandler(result, error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: dataRecieved!, options: []) as? Dictionary<String, Any>
                if let json = json {
                    let rates = json["rates"] as! Dictionary<String, Any>
                    for (currency, rate) in rates {
                        let model = CurrencyModel(currency: currency, rate: rate as! NSNumber)
                        result.append(model)
                    }
                }
            } catch {
                result = []
            }
            parseHandler(result, error)
        }
        dataTask.resume()
    }
    
    func requestCurrency(baseCurrency: String, toCurrency: String, amount: Double, callback: @escaping (String, Error?) -> Void) {
        var value : String = ""
        let url = URL(string: Constants.latestCurrency+baseCurrency)
        
        let dataTask = URLSession.shared.dataTask(with: url!) {(dataRecieved, response, error) in
            let result = self.parseCurrencyRateResponse(data: dataRecieved, toCurrency: toCurrency, amount: amount)
            if let result = result {
                value = result
            } else {
                value = (error?.localizedDescription)!
            }
            callback(value, error)
        }
        dataTask.resume()
    }
    
    func parseCurrencyRateResponse(data: Data?, toCurrency: String, amount: Double) -> String? {
        var value: String = ""
        
        guard data != nil else {
            value = NSLocalizedString("rate-fetch-failed", comment: "fetch failed message")
            return value
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String, Any>
            
            if let parsedJson = json {
                if let rates = parsedJson["rates"] as? Dictionary<String, Double> {
                    if let rate = rates[toCurrency] {
                        value = "\(rate * amount)"
                    } else {
                        value = NSLocalizedString("rate-fetch-failed", comment: "fetch failed message")
                    }
                } else {
                    value = NSLocalizedString("rate-fetch-failed", comment: "fetch failed message")
                }
            } else {
                value = NSLocalizedString("rate-fetch-failed", comment: "fetch failed message")
            }
        } catch {
            value = error.localizedDescription
        }
        
        return value
    }
}
