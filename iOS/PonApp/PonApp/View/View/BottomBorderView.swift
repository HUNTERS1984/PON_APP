//
//  BottomBorderView.swift
//  PonApp
//
//  Created by HaoLe on 9/6/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class BottomBorderView: UIView {
    @IBInspectable var marginLeft: CGFloat = 0
    @IBInspectable var marginRight: CGFloat = 0
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1.0)
        CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor().CGColor)
        CGContextMoveToPoint(context, marginLeft, rect.size.height)
        CGContextAddLineToPoint(context, rect.size.width - marginRight, rect.size.height)
        CGContextStrokePath(context)
        
    }
    
}
