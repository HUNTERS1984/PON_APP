//
//  UIViewExtension.swift
//  SpaOwnerIOS
//
//  Created by HaoLe on 7/4/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

extension UIView {
    
    /*
     *** Class Methods ***
     */
    class func loadViewFromNib(nibName: String! = nil, bundle: NSBundle! = nil) -> UIView!{
        var defaultNibName: String! = nil
        if nibName == nil {
            let fullClassName = NSStringFromClass(self)
            if let className = fullClassName.componentsSeparatedByString(".").last {
                defaultNibName = className
            }
        }else {
            defaultNibName = nibName
        }
        let nib = UINib(nibName: defaultNibName, bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    class func loadViewFromNib(nibName: String) -> UIView {
        
        let nib = UINib(nibName: nibName, bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    public class func fromNib(nibNameOrNil: String? = nil) -> Self {
        return fromNib(nibNameOrNil, type: self)
    }
    
    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
        let v: T? = fromNib(nibNameOrNil, type: T.self)
        return v!
    }
    
    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = nibName
        }
        let nibViews = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
        for v in nibViews {
            if let tog = v as? T {
                view = tog
            }
        }
        return view
    }
    
    public class var nibName: String {
        let name = "\(self)".componentsSeparatedByString(".").first ?? ""
        return name
    }
    public class var nib: UINib? {
        if let _ = NSBundle.mainBundle().pathForResource(nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
}
