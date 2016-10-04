//
//  FullScreenSlideshowViewController.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 31.08.15.
//

import UIKit

public class FullScreenSlideshowViewController: UIViewController {
    
    public var slideshow: ImageSlideshow = {
        let slideshow = ImageSlideshow()
        slideshow.zoomEnabled = true
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        slideshow.pageControlPosition = PageControlPosition.InsideScrollView
        // turns off the timer
        slideshow.slideshowInterval = 0
        slideshow.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        return slideshow
    }()
    
    public var closeButton = UIButton()
    public var pageSelected: ((_ page: Int) -> ())?
    
    /// Index of initial image
    public var initialImageIndex: Int = 0
    public var inputs: [InputSource]?
    
    /// Background color
    public var backgroundColor = UIColor.black
    
    /// Enables/disable zoom
    public var zoomEnabled = true {
        didSet {
            slideshow.zoomEnabled = zoomEnabled
        }
    }
    
    private var isInit = true
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backgroundColor
        
        // slideshow view configuration
        slideshow.frame = view.frame
        slideshow.backgroundColor = backgroundColor
        
        if let inputs = inputs {
            slideshow.setImageInputs(inputs: inputs)
        }
        
        slideshow.frame = view.frame
        view.addSubview(slideshow);
        
        // close button configuration
        closeButton.frame = CGRect(x:10, y:20, width:40, height:40)
        closeButton.setImage(UIImage(named: "ic_cross_white@2x"), for: UIControlState.normal)
        closeButton.addTarget(self, action: #selector(FullScreenSlideshowViewController.close), for: UIControlEvents.touchUpInside)
        view.addSubview(closeButton)
    }
    
    override public var prefersStatusBarHidden: Bool {
        get {
            return true
        }  
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isInit {
            isInit = false
            slideshow.setScrollViewPage(scrollViewPage: initialImageIndex, animated: false)
        }
    }
    
    func close() {
        // if pageSelected closure set, send call it with current page
        if let pageSelected = pageSelected {
            pageSelected(slideshow.scrollViewPage)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
