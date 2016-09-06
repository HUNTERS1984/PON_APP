//
//  CouponBannerView.swift
//  PonApp
//
//  Created by HaoLe on 9/6/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class CouponBannerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1.0)
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        let rectangle = CGRectMake(0,rect.size.height * (20/95), rect.size.width, rect.size.height - (rect.size.height * (20/95)))
        CGContextAddRect(context, rectangle)
        CGContextFillPath(context)
    }

}
