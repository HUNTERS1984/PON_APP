//
//  FullScreenPhotoViewController.swift
//  PonApp
//
//  Created by HaoLe on 11/2/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import SnapKit

class PhotoViewerViewController: BaseViewController {
    var didSetupConstraints = false
    
    let imageScrollView: ImageScrollView = {
        let imageView = ImageScrollView()
        return imageView
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "nav_close_blue"), for: .normal)
        return button
    }()
    
    var url: String = ""
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(imageScrollView)
        closeButton.addTarget(self, action: #selector(PhotoViewerViewController.close), for: .touchUpInside)
        view.addSubview(closeButton)
        view.setNeedsUpdateConstraints()
    }
    
    override public var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageScrollView.display(imageUrl: self.url)
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    open func setImageUrl(url: String) {
        self.url = url
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            imageScrollView.snp.makeConstraints { make in
                make.top.equalTo(view).inset(0)
                make.leading.equalTo(view).inset(0)
                make.trailing.equalTo(view).inset(0)
                make.bottom.equalTo(view).inset(0)
            }
            
            closeButton.snp.makeConstraints { make in
                make.top.equalTo(view).offset(22.0)
                make.left.equalTo(view).offset(0.0)
                make.size.equalTo(CGSize(width: 40.0, height:40.0))
            }
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
}

extension PhotoViewerViewController {
    

}
