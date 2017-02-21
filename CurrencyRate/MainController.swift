//
//  MainController.swift
//  CurrencyRate
//
//  Created by Юрий Логинов on 20.02.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    
    weak var activeLabel: UILabel?
    
    var firstCurrency: String = "USD"
    var secondCurrency: String = "RUB"
    let zeroSymbol: String = "0"
    let dotSymbol: String = "."

    @IBOutlet weak var numberPad: NumPad!
    @IBOutlet weak var currencyField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var firstCurrencyLabel: UILabel!
    @IBOutlet weak var secondCurrencyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setup() {
        navigationController?.setBaseStyle()
        numberPad.delegate = self
    }
    
    @IBAction func actionSwapTap(_ sender: Any) {
        ServerManager.shared.requestCurrency(baseCurrency: firstCurrency, toCurrency: secondCurrency, amount: Double(currencyField.text!)!) { [weak self](result, error) in
            DispatchQueue.main.async(execute: {
                if let strongSelf = self {
                    if error != nil {
                        strongSelf.present(UIAlertController.alert(title: result, message: (error?.localizedDescription)!), animated: true, completion: nil)
                    } else {
                        strongSelf.resultLabel.text = result
                    }
                }
            })
        }
    }
    
    @IBAction func firstCurrencyGesture(_ sender: UITapGestureRecognizer) {
        activeLabel = firstCurrencyLabel
        present(selectCurrencyController(title: firstCurrency), animated: true, completion: nil)
    }

    @IBAction func secondCurrencyGesture(_ sender: UITapGestureRecognizer) {
        activeLabel = secondCurrencyLabel
        present(selectCurrencyController(title: secondCurrency), animated: true, completion: nil)
    }
    
    private func selectCurrencyController(title: String) -> UINavigationController {
        let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: CurrencySelectController.self)) as? CurrencySelectController
        vc?.currencyTitle = title
        vc?.delegate = self
        let navigation = UINavigationController.init(rootViewController: vc!)
        return navigation
    }
}

extension MainController : NumPadDelegate {
    func numberPad(pad: NumPad, didTap:Int) {
        let number = "\(didTap)"
        if currencyField.text == zeroSymbol {
            currencyField.text = number
        } else {
            currencyField.text?.append(number)
        }
    }
    
    func numberPadDotTap(pad: NumPad) {
        if (currencyField.text?.contains(dotSymbol))! {
            return
        } else {
            if (currencyField.text?.characters.count)! > 0 {
                currencyField.text?.append(dotSymbol)
            }
        }
    }
    
    func numberPadBackspaceTap(pad: NumPad) {
        if currencyField.text == zeroSymbol {
            return
        }
        if (currencyField.text?.characters.count)! == 1 {
            currencyField.text = zeroSymbol
        } else {
            currencyField.text?.remove(at: (currencyField.text?.index(before: (currencyField.text?.endIndex)!))!)
        }
    }
}

extension MainController: CurrencySelectDelegate {
    func currencySelected(currency: String) {
        if activeLabel == firstCurrencyLabel {
            firstCurrencyLabel.text = currency
            firstCurrency = currency
        } else if activeLabel == secondCurrencyLabel {
            secondCurrencyLabel.text = currency
            secondCurrency = currency
        }
        activeLabel = nil
    }
}

