//
//  PonButton.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class PonButton: UIButton {
    
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
        CGContextSetStrokeColorWithColor(context,
                                         UIColor.blueColor().CGColor)
        let rectangle = CGRectMake(2, 2, rect.width - 4, rect.height - 4)
        CGContextAddEllipseInRect(context, rectangle)
        CGContextSetFillColorWithColor(context, UIColor(hex: 0x18c0d4).CGColor)
        CGContextFillPath(context)
    }

}
