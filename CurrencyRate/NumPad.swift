//
//  NumPad.swift
//  CurrencyRate
//
//  Created by Юрий Логинов on 20.02.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

import Foundation
import UIKit

protocol NumPadDelegate: class {
    func numberPad(pad: NumPad, didTap:Int)
    func numberPadDotTap(pad: NumPad)
    func numberPadBackspaceTap(pad: NumPad)
}

class NumPad : UIView {
    
    weak var delegate: NumPadDelegate?
    var contentView : UIView?
    
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()
        contentView!.frame = bounds
        addSubview(contentView!)
    }
    
    func loadViewFromNib() -> UIView! {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    @IBAction func actionButtonTap(_ sender: UIButton) {
        delegate?.numberPad(pad: self, didTap: sender.tag)
    }
    
    @IBAction func actionDotTap(_ sender: Any) {
        delegate?.numberPadDotTap(pad: self)
    }
    
    @IBAction func actionBackspaceTap(_ sender: Any) {
        delegate?.numberPadBackspaceTap(pad: self)
    }
}
