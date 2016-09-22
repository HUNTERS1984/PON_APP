//
//  RightBorderView.swift
//  PonApp
//
//  Created by HaoLe on 9/7/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class RightBorderView: UIView {
    @IBInspectable var marginRight: CGFloat = 0
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 0.5)
        CGContextSetStrokeColorWithColor(context, UIColor(hex: DefaultBorderColor).CGColor)
        CGContextMoveToPoint(context, rect.size.width - marginRight, 0)
        CGContextAddLineToPoint(context, rect.size.width - marginRight, rect.size.height)
        CGContextStrokePath(context)
        
    }

}
