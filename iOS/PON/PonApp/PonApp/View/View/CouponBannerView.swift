//
//  CouponBannerView.swift
//  PonApp
//
//  Created by HaoLe on 9/6/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class CouponBannerView: UIView {

    var bottomBorderColor: UIColor = UIColor(hex: DefaultBorderColor)
    
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
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(0.5)
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setFillColor(UIColor.white.cgColor)
        let rectangle = CGRect(x: 0,y: rect.size.height * (25/95), width: rect.size.width, height: rect.size.height - (rect.size.height * (25/95)))
        context?.addRect(rectangle)
        context?.fillPath()
        
        
        context?.setLineWidth(0.5)
        context?.setStrokeColor(bottomBorderColor.cgColor)
        context?.move(to: CGPoint(x: 15, y: rect.size.height))
        context?.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height))
        context?.strokePath()
    }

}
