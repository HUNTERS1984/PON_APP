//
//  TypeConversionHelper.swift
//  CouponFinder
//
//  Created by HaoLe on 12/8/15.
//  Copyright © 2015 HaoLe. All rights reserved.
//


import Foundation
import UIKit

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var intValue: Int32 {
        return (self as NSString).intValue
    }
    
    var integerValue: Int {
        return (self as NSString).integerValue
    }
    
    var CGFloatValue: CGFloat {
        return CGFloat( (self as NSString).floatValue )
    }
    
    var NSStringValue: NSString {
        return (self as NSString)
    }
}

extension CGFloat {
    var UInt32Value: UInt32 {
        return UInt32(UInt(self))
    }
}

extension Double {
    var CGFloatValue: CGFloat {
        return CGFloat(self)
    }
}

extension Float {
    var CGFloatValue: CGFloat {
        return CGFloat(self)
    }
}

extension Int {
    var CGFloatValue: CGFloat {
        return CGFloat(self)
    }
}

extension UInt32 {
    var CGFloatValue: CGFloat {
        return CGFloat(UInt(self))
    }
    
}
