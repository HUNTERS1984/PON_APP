//
//  HLKAlertView.swift
//  CouponFinder
//
//  Created by HaoLe on 12/11/15.
//  Copyright © 2015 HaoLe. All rights reserved.
//

import UIKit

class UIAlertViewExt: UIAlertView {
    var handler: ((selectedOption: String) -> ())?
}

class HLKAlertView: NSObject, UIAlertViewDelegate {
    
    class var defaultInstance: HLKAlertView {
        struct Static {
            static var instance: HLKAlertView?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = HLKAlertView()
        }
        
        return Static.instance!
    }
    
    class func show(title: String?, message: String?, accessoryView: UIView?, cancelButtonTitle: String?, otherButtonTitles: [String]?, handler: ((selectedOption: String) -> ())?) -> UIAlertView {
        
        let alertView = UIAlertViewExt(title: title, message: message, delegate: self.defaultInstance, cancelButtonTitle: nil)
        
        if let accessoryView = accessoryView {
            alertView.setValue(accessoryView, forKey: "accessoryView")
        }
        
        if let otherButtonTitles = otherButtonTitles {
            for buttonTitle in otherButtonTitles {
                alertView.addButtonWithTitle(buttonTitle)
            }
        }
        
        if let _ = cancelButtonTitle {
            alertView.cancelButtonIndex = alertView.addButtonWithTitle(cancelButtonTitle!)
        }
        
        alertView.handler = handler
        
        dispatch_async(dispatch_get_main_queue(), {
            alertView.show()
        })
        
        return alertView
    }
    
    // MARK: UIAlertViewDelegate
    func alertView(alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int) {
        if let alertView = alertView as? UIAlertViewExt {
            alertView.setValue(nil, forKey: "accessoryView")
            alertView.handler?(selectedOption: alertView.buttonTitleAtIndex(buttonIndex)!)
        }
    }
    
}
