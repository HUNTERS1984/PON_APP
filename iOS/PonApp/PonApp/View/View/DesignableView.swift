//
//  DesignableView.swift
//  PonApp
//
//  Created by HaoLe on 9/6/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class DesignableView: UIView {

    // IBInspectable properties for the gradient colors
    @IBInspectable var bottomColor: UIColor = UIColor.whiteColor()
    @IBInspectable var middleColor: UIColor = UIColor.whiteColor()
    @IBInspectable var topColor: UIColor = UIColor.whiteColor()
    @IBInspectable var bottomColorAlpha: CGFloat = 1.0
    @IBInspectable var middleColorAlpha: CGFloat = 1.0
    @IBInspectable var topColorAlpha: CGFloat = 1.0
    
    // IBInspectable properties for rounded corners and border color / width
    @IBInspectable var cornerSize: CGFloat = 0
    @IBInspectable var borderSize: CGFloat = 0
    @IBInspectable var borderColor: UIColor = UIColor(hex: DefaultBorderColor)
    @IBInspectable var borderAlpha: CGFloat = 1.0
    
    override func drawRect(rect: CGRect) {
        
        // set up border and cornerRadius
        self.layer.cornerRadius = cornerSize
        self.layer.borderColor = borderColor.colorWithAlphaComponent(borderAlpha).CGColor
        self.layer.borderWidth = borderSize
        self.layer.masksToBounds = true
        
        // set up gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = rect
        let c1 = bottomColor.colorWithAlphaComponent(bottomColorAlpha).CGColor
        let c2 = middleColor.colorWithAlphaComponent(middleColorAlpha).CGColor
        let c3 = topColor.colorWithAlphaComponent(topColorAlpha).CGColor
        gradientLayer.colors = [c3, c2, c1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradientLayer, atIndex: 0)
        
    }

}
