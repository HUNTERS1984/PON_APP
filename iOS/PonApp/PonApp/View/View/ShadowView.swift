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
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    func addShadow(shadowOpacity: Float = 0.4, shadowRadius: CGFloat = 1.0) {
        backgroundColor = UIColor.clearColor()
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
}


