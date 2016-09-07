//
//  RightBorderView.swift
//  PonApp
//
//  Created by HaoLe on 9/7/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class RightBorderView: UIView {

    @IBInspectable var bottomBorderColor: UIColor = UIColor(red:80.0/255.0, green:90.0/255.0, blue:94.0/255.0, alpha:1)
    @IBInspectable var bottomBorderColorAlpha: CGFloat = 1.0
    @IBInspectable var marginRight: CGFloat = 0
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1.0)
        CGContextSetStrokeColorWithColor(context, bottomBorderColor.CGColor)
        CGContextMoveToPoint(context, rect.size.width - marginRight, 0)
        CGContextAddLineToPoint(context, rect.size.width - marginRight, rect.size.height)
        CGContextStrokePath(context)
        
    }

}
