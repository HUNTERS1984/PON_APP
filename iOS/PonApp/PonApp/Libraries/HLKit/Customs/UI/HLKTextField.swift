//
//  HLKTextField.swift
//  CouponFinder
//
//  Created by HaoLe on 12/11/15.
//  Copyright © 2015 HaoLe. All rights reserved.
//

import UIKit

class HLKTextField: UITextField {
    
    //MARK: - Private
    fileprivate var errorIcon: UIImageView!
    fileprivate var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)
    
    //MARK: - Public
    var nextField: AnyObject?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, padding))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: UIEdgeInsetsInsetRect(bounds, padding))
    }
}

extension HLKTextField {
    
    fileprivate func initialize() {
        self.addTarget(self, action: #selector(HLKTextField.focusNextField(_:)), for: UIControlEvents.editingDidEndOnExit)
        let screenWidth = UIScreen.main.bounds.width
        let line = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 1))
        line.backgroundColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1)
        self.inputAccessoryView = line
        
        let errorI = UIImage(named: "error-icon")
        self.errorIcon = UIImageView(image: errorI)
        self.errorIcon.center = CGPoint(x: self.bounds.size.width - errorI!.size.width, y: self.bounds.size.height/2)
        self.errorIcon?.isHidden = true
        self.addSubview(self.errorIcon)
    }
    
    @IBAction func focusNextField(_ sender: AnyObject) {
        if let _ = nextField {
            nextField?.becomeFirstResponder()
        }else {
            self.resignFirstResponder()
        }
    }
    
}

extension HLKTextField {
    
    func showErrorIcon(_ showed: Bool) {
        if showed {
            self.errorIcon.isHidden = false
        }else {
            self.errorIcon.isHidden = true
        }
    }
    
}
