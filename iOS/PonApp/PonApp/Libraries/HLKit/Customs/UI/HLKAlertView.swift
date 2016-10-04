//
//  HLKAlertView.swift
//  CouponFinder
//
//  Created by HaoLe on 12/11/15.
//  Copyright © 2015 HaoLe. All rights reserved.
//

import UIKit

class UIAlertViewExt: UIAlertView {
    var handler: ((_ selectedOption: String) -> ())?
}

class HLKAlertView: NSObject, UIAlertViewDelegate {
    
    class var sharedInstance: HLKAlertView {
        struct Static {
            static let instance = HLKAlertView()
        }
        return Static.instance
    }
    
    class func show(_ title: String?, message: String?, accessoryView: UIView? = nil, cancelButtonTitle: String?, otherButtonTitles: [String]?, handler: ((_ selectedOption: String) -> ())?) {
        
        let alertView = UIAlertViewExt(title: title, message: message, delegate: self, cancelButtonTitle: nil)
        
        if let accessoryView = accessoryView {
            alertView.setValue(accessoryView, forKey: "accessoryView")
        }
        
        if let otherButtonTitles = otherButtonTitles {
            for buttonTitle in otherButtonTitles {
                alertView.addButton(withTitle: buttonTitle)
            }
        }
        
        if let _ = cancelButtonTitle {
            alertView.cancelButtonIndex = alertView.addButton(withTitle: cancelButtonTitle!)
        }
        
        alertView.handler = handler
        
        DispatchQueue.main.async(execute: {
            alertView.show()
        })
    }
    
    // MARK: UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int) {
        if let alertView = alertView as? UIAlertViewExt {
            alertView.setValue(nil, forKey: "accessoryView")
            alertView.handler?(alertView.buttonTitle(at: buttonIndex)!)
        }
    }
    
}
