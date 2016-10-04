//
//  TabbarView.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class TabbarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        self.backgroundColor = UIColor.white
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(0.5)
        context?.setStrokeColor(UIColor(hex: DefaultBorderColor).cgColor)
        context?.move(to: CGPoint(x: 0, y: 10))
        context?.addLine(to: CGPoint(x: rect.width, y: 10))
        context?.strokePath()
    }

}
