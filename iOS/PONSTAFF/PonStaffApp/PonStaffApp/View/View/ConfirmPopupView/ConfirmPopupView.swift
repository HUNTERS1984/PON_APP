//
//  ConfirmPopupView.swift
//  PonStaffApp
//
//  Created by HaoLe on 10/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

typealias AcceptButtonPressed = () -> ()
typealias RejectButtonPressed = () -> ()

class ConfirmPopupView: PopupView {
    
    var acceptButtonPressed: AcceptButtonPressed? = nil
    var rejectButtonPressed: RejectButtonPressed? = nil

    public static func create() -> ConfirmPopupView {
        let popup = self.loadViewFromNib() as! ConfirmPopupView
        popup.frame = UIScreen.main.bounds
        return popup
    }

    @IBAction func acceptButtonPressed(_ sender: AnyObject) {
        self.acceptButtonPressed?()
    }
    
    @IBAction func rejectButtonPressed(_ sender: AnyObject) {
        self.rejectButtonPressed?()
    }
    
}
