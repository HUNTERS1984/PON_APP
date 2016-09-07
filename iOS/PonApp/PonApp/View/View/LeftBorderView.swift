//
//  LeftBorderView.swift
//  PonApp
//
//  Created by HaoLe on 9/7/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class LeftBorderView: UIView {
    @IBInspectable var marginLeft: CGFloat = 0
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1.0)
        CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor().CGColor)
        CGContextMoveToPoint(context, marginLeft, 0)
        CGContextAddLineToPoint(context, marginLeft, rect.size.height)
        CGContextStrokePath(context)
        
    }

}
