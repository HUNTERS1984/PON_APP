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
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1.0)
        context?.setStrokeColor(UIColor(hex: DefaultBorderColor).cgColor)
        context?.move(to: CGPoint(x: marginLeft, y: rect.size.height - 1.0))
        context?.addLine(to: CGPoint(x: rect.size.width - marginRight, y: rect.size.height - 1.0))
        context?.strokePath()
        
    }
    
}
