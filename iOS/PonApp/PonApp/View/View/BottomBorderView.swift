//
//  BottomBorderView.swift
//  PonApp
//
//  Created by HaoLe on 9/6/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class BottomBorderView: UIView {

    @IBInspectable var bottomBorderColor: UIColor = UIColor(red:200.0/255.0, green:210.0/255.0, blue:214.0/255.0, alpha:1)
    @IBInspectable var bottomBorderColorAlpha: CGFloat = 1.0
    @IBInspectable var marginLeft: CGFloat = 0
    @IBInspectable var marginRight: CGFloat = 0
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        CGContextSetStrokeColorWithColor(context, bottomBorderColor.CGColor)
        CGContextMoveToPoint(context, marginLeft, rect.size.height)
        CGContextAddLineToPoint(context, rect.size.width - marginRight, rect.size.height)
        CGContextStrokePath(context)
        
    }
    
}
