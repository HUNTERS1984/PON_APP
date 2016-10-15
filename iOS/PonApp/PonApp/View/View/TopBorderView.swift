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
    
    override func draw(_ rect: CGRect) {
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.setLineWidth(1.0)
            ctx.setStrokeColor(UIColor(hex: DefaultBorderColor).cgColor)
            ctx.move(to: CGPoint(x: marginLeft, y: 0))
            ctx.addLine(to: CGPoint(x: rect.size.width - marginRight, y: 0))
            ctx.drawPath(using: .fillStroke)
            UIGraphicsEndImageContext()
        }
    }

}
