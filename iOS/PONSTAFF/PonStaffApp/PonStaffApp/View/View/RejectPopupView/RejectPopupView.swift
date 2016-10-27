//
//  RejectPopupView.swift
//  PonStaffApp
//
//  Created by HaoLe on 10/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class RejectPopupView: PopupView {
    
    public static func create() -> RejectPopupView {
        let popup = self.loadViewFromNib() as! RejectPopupView
        popup.frame = UIScreen.main.bounds
        return popup
    }
    
    @IBAction func donetButtonPressed(_ sender: AnyObject) {
        self.doneButtonPressed?()
    }

}
