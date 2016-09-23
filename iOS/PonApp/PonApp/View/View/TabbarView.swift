//
//  TabbarView.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class TabbarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        self.backgroundColor = UIColor.whiteColor()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 0.5)
        CGContextSetStrokeColorWithColor(context, UIColor(hex: DefaultBorderColor).CGColor)
        CGContextMoveToPoint(context, 0, 10)
        CGContextAddLineToPoint(context, rect.width, 10)
        CGContextStrokePath(context)
    }

}
