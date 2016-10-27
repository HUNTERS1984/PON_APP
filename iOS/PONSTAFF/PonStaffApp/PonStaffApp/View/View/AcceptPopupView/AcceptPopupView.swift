//
//  AcceptPopupView.swift
//  PonStaffApp
//
//  Created by HaoLe on 10/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class AcceptPopupView: PopupView {

    public static func create() -> AcceptPopupView {
        let popup = self.loadViewFromNib() as! AcceptPopupView
        popup.frame = UIScreen.main.bounds
        return popup
    }
    
    @IBAction func donetButtonPressed(_ sender: AnyObject) {
        self.doneButtonPressed?()
    }
    
}
