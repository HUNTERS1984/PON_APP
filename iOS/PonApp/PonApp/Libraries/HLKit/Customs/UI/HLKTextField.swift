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
    private var errorIcon: UIImageView!
    private var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)
    
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
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, padding))
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return super.editingRectForBounds(UIEdgeInsetsInsetRect(bounds, padding))
    }
}

extension HLKTextField {
    
    private func initialize() {
        self.addTarget(self, action: #selector(HLKTextField.focusNextField(_:)), forControlEvents: UIControlEvents.EditingDidEndOnExit)
        let screenWidth = UIScreen.mainScreen().bounds.width
        let line = UIView(frame: CGRectMake(0, 0, screenWidth, 1))
        line.backgroundColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1)
        self.inputAccessoryView = line
        
        let errorI = UIImage(named: "error-icon")
        self.errorIcon = UIImageView(image: errorI)
        self.errorIcon.center = CGPointMake(self.bounds.size.width - errorI!.size.width, self.bounds.size.height/2)
        self.errorIcon?.hidden = true
        self.addSubview(self.errorIcon)
    }
    
    @IBAction func focusNextField(sender: AnyObject) {
        if let _ = nextField {
            nextField?.becomeFirstResponder()
        }else {
            self.resignFirstResponder()
        }
    }
    
}

extension HLKTextField {
    
    func showErrorIcon(showed: Bool) {
        if showed {
            self.errorIcon.hidden = false
        }else {
            self.errorIcon.hidden = true
        }
    }
    
}