//
//  UIScrollViewExtension.swift
//  PonApp
//
//  Created by HaoLe on 10/17/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func scrollToTop() {
        DispatchQueue.main.async { () -> Void in
            let desiredOffset = CGPoint(x: 0, y: -self.contentInset.top)
            self.setContentOffset(desiredOffset, animated: true)
        }
    }
    
}
