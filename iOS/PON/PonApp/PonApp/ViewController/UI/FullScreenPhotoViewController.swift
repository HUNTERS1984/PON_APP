//
//  FullScreenPhotoViewController.swift
//  PonApp
//
//  Created by HaoLe on 11/2/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: BaseViewController {
    
    public var closeButton = UIButton()
    public var backgroundColor = UIColor.white
    fileprivate var imageScrollView: ImageScrollView?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        
        // close button configuration
        closeButton.frame = CGRect(x:0, y:22, width:40, height:40)
        closeButton.setImage(UIImage(named: "nav_close_blue"), for: UIControlState.normal)
        closeButton.addTarget(self, action: #selector(self.close), for: UIControlEvents.touchUpInside)
        view.addSubview(closeButton)
        view.bringSubview(toFront: closeButton)
    }
    
    override public var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    open func setImageUrl(url: String) {
        if let _ = self.imageScrollView {
            self.imageScrollView!.removeFromSuperview()
        }
        imageScrollView = ImageScrollView(frame: self.view.bounds)
        self.view.addSubview(imageScrollView!)
        self.view.sendSubview(toBack: imageScrollView!)
        imageScrollView?.display(imageUrl: url)
    }
    
}
