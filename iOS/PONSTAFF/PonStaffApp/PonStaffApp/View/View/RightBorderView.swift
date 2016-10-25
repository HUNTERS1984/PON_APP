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
    
    override func draw(_ rect: CGRect) {
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.setLineWidth(1.0)
            ctx.setStrokeColor(UIColor(hex: DefaultBorderColor).cgColor)
            ctx.move(to: CGPoint(x: rect.size.width - marginRight - 1.0, y: 0))
            ctx.addLine(to: CGPoint(x: rect.size.width - marginRight - 1.0, y: rect.size.height - 0.5))
            ctx.drawPath(using: .fillStroke)
            UIGraphicsEndImageContext()
        }
    }

}
