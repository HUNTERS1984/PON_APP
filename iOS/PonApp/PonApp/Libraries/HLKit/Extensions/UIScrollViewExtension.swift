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
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
    
}
