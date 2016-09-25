//
//  ShadowView.swift
//  ShadowView
//
//  Created by Ben Boecker on 18.03.16.
//  Copyright © 2016 Ben Boecker. All rights reserved.
//

import UIKit
import QuartzCore

class ShadowView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0
    @IBInspectable var shadowColor: UIColor = UIColor(hex: DefaultBorderColor)
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0)
    @IBInspectable var shadowRadius: CGFloat = 0.0
    @IBInspectable var shadowOpacity: Float = 0.6
    
    override func drawRect(rect: CGRect) {
        self.updateProperties()
    }
    
    private func updateProperties() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowColor = self.shadowColor.CGColor
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowOpacity = self.shadowOpacity
        self.layer.borderWidth = 0.5
        self.layer.borderColor = self.shadowColor.CGColor
    }
    
    private func updateShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).CGPath
    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.updateProperties()
//        self.updateShadowPath()
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateShadowPath()
    }
}


