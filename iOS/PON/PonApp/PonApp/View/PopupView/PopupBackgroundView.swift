//
//  PopupBackgroundView.swift
//  PonStaffApp
//
//  Created by HaoLe on 10/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class PopupBackgroundView: UIView {

    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }

}
