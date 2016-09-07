//
//  CircleImageView.swift
//  PonApp
//
//  Created by HaoLe on 9/7/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    
    @IBInspectable var imageBorderColor: UIColor = UIColor(red:162.0/255.0, green:169.0/255.0, blue:175.0/255.0, alpha:1)
    @IBInspectable var borderSize: CGFloat = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
         self.setupImageView()
    }
    
    private func setupImageView() {
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.layer.borderColor = self.imageBorderColor.CGColor
        self.layer.borderWidth = self.borderSize
        self.backgroundColor = UIColor.whiteColor()
    }

}
