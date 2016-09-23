//
//  TopBorderView.swift
//  PonApp
//
//  Created by HaoLe on 9/13/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class TopBorderView: UIView {

    @IBInspectable var marginLeft: CGFloat = 0
    @IBInspectable var marginRight: CGFloat = 0
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 0.5)
        CGContextSetStrokeColorWithColor(context, UIColor(hex: DefaultBorderColor).CGColor)
        CGContextMoveToPoint(context, marginLeft, 0)
        CGContextAddLineToPoint(context, rect.size.width - marginRight, 0)
        CGContextStrokePath(context)
        
    }

}
