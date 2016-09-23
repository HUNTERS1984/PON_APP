//
//  UICollectionViewExtension.swift
//  PonApp
//
//  Created by HaoLe on 9/23/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func reloadData(completion: ()->()) {
        UIView.animateWithDuration(0, animations: { self.reloadData() })
        { _ in completion() }
    }
    
}
