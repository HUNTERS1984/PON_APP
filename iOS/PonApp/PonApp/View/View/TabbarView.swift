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
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let ctx = UIGraphicsGetCurrentContext() {
            let rectangle = CGRect(x: 0, y: 10, width: rect.width, height: rect.height - 10)
            ctx.setFillColor(UIColor.white.cgColor)
            ctx.setStrokeColor(UIColor.white.cgColor)
            ctx.setLineWidth(1.0)
            ctx.addRect(rectangle)
            ctx.drawPath(using: .fillStroke)
            UIGraphicsEndImageContext()
        }
        
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.setStrokeColor(UIColor(hex: DefaultBorderColor).cgColor)
            ctx.setLineWidth(0.5)
            ctx.move(to: CGPoint(x: 0, y: 10))
            ctx.addLine(to: CGPoint(x: rect.width, y: 10))
            ctx.drawPath(using: .stroke)
            UIGraphicsEndImageContext()
        }
    }

}
