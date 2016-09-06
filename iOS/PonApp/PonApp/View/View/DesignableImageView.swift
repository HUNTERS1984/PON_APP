//
//  DesignableImageView.swift
//  PonApp
//
//  Created by HaoLe on 9/6/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class DesignableImageView: UIImageView {

    @IBInspectable var borderColor : UIColor = UIColor.clearColor()
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var cornerRadius: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.borderColor = borderColor.CGColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
    }

}
