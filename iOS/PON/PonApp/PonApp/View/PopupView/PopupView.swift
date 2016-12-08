//
//  PopupView.swift
//  PonStaffApp
//
//  Created by HaoLe on 10/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

let TransformScaleX: CGFloat = 1.3
let AnimationDuration: CGFloat = 0.25

typealias PopupDidShow = () -> ()
typealias PopupDidHide = () -> ()
typealias DoneButtonPressed = () -> ()

class PopupView: UIView {
    
    var popupDidShowCallback: PopupDidShow? = nil
    var popupDidHideCallback: PopupDidHide? = nil
    var doneButtonPressed: DoneButtonPressed? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapBackground(_:)))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc
    fileprivate func handleTapBackground(_ sender: UITapGestureRecognizer) {
        self.hideAnimate()
    }
    
    func showAnimate() {
        self.transform = CGAffineTransform(scaleX: TransformScaleX, y: TransformScaleX)
        self.alpha = 0.0
        UIView.animate(withDuration: TimeInterval(AnimationDuration)) { 
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.popupDidShowCallback?()
        }
    }
    
    func hideAnimate() {
        UIView.animate(withDuration: TimeInterval(AnimationDuration), animations: { 
            self.alpha = 0
            }) { _ in
                self.removeFromSuperview()
                self.popupDidHideCallback?()
        }
    }
    
    func showPopup(inView view: UIView, animated: Bool) {
        let window = UIApplication.shared.delegate?.window
        window!?.addSubview(self)
        if animated {
            self.showAnimate()
        }
    }
    
    func hidePopup() {
        self.hideAnimate()
    }

}

extension PopupView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != self {
            return false
        }else {
            return true
        }
    }
}
