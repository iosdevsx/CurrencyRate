//
//  CurrencySelectController.swift
//  CurrencyRate
//
//  Created by Юрий Логинов on 21.02.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

import Foundation
import UIKit

protocol CurrencySelectDelegate: class {
    func currencySelected(currency: String)
}

class CurrencySelectController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: CurrencySelectDelegate?
    var refreshControl: UIRefreshControl?
    
    public var currencyTitle: String?
    
    let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.minimumIntegerDigits = 1
        return numberFormatter
    }()
    
    var items: Array<CurrencyModel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchCurrencies()
    }
    
    public func fetchCurrencies() {
        if let currencyTitle = currencyTitle {
            ServerManager.shared.requestCurrencyList(baseCurrency: currencyTitle) { [weak self] (response, error) in
                DispatchQueue.main.async(execute: {
                    if let strongSelf = self {
                        
                        if (strongSelf.refreshControl?.isRefreshing)! {
                            strongSelf.refreshControl?.endRefreshing()
                        }
                        
                        if error != nil {
                            strongSelf.present(UIAlertController.alert(title: NSLocalizedString("error-title", comment: "error title"), message: (error?.localizedDescription)!), animated: true, completion: nil)
                        } else {
                            strongSelf.items = response
                            strongSelf.tableView.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        navigationController?.navigationBar.frame = CGRect.init(x: 0, y: 0, width: 320, height: 64);
        super.viewDidLayoutSubviews()
    }
    
    public func setup() {
        refreshControl = UIRefreshControl.init()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl!)
        navigationItem.title = currencyTitle!
        setCloseButton()
        navigationController?.setBaseStyle()
        tableView.register(UINib.init(nibName: String(describing: CurrencyCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: CurrencyCell.self))
    }
    
    public func refresh() {
        fetchCurrencies()
    }
    
    public func setCloseButton() {
        let button = UIBarButtonItem.init(title: NSLocalizedString("close", comment: "close button"), style: .done, target: self, action:#selector(close))
        button.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CurrencySelectController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CurrencyCell.self)) as? CurrencyCell
        let currentCurrency = items[indexPath.row]
        cell?.currencyLabel.text = currentCurrency.currency
        cell?.amountLabel.text = numberFormatter.string(from: currentCurrency.rate!)
        return cell!
    }
}

extension CurrencySelectController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.currencySelected(currency: items[indexPath.row].currency!)
        close()
    }
}
