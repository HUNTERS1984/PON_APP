//
//  CouponViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/6/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import ImageSlideshow

class CouponViewController: BaseViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    @IBOutlet weak var couponInfoLabel: UILabel!
    
    var transitionDelegate: ZoomAnimatedTransitioningDelegate?
    var point: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let text = "この日は国連が定めた「国際ヨガの日 夏至は１年で最も昼の時間が長いことから、自然との調和を重んじるヨガの世界では特別な日とされて この日は国連が定めた「国際ヨガの日 夏至は１年で最も昼の時間が長いことから、自然との調和を重んじるヨガの世界では特別な日とされて この日は国連が定めた「国際ヨガの日 夏至は１年で最も昼の時間が長いことから、自然との調和を重んじるヨガの世界では特別な日とされて この日は国連が定めた「国際ヨガの日 夏至は１年で最も昼の時間が長いことから、自然との調和を重んじるヨガの世界では特別な日とされて この日は国連が定めた「国際ヨガの日"
        self.couponInfoLabel.text = text
        self.setupImageSlideShow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

//MARK: - IBAction
extension CouponViewController {
    
    func clickOnImageSlideShow() {
        let ctr = FullScreenSlideshowViewController()
        ctr.pageSelected = {(page: Int) in
            self.imageSlideshow.setScrollViewPage(page, animated: false)
        }
        
        ctr.initialImageIndex = imageSlideshow.scrollViewPage
        ctr.inputs = imageSlideshow.images
        self.transitionDelegate = ZoomAnimatedTransitioningDelegate(slideshowView: imageSlideshow, slideshowController: ctr)
        // Uncomment if you want disable the slide-to-dismiss feature
        // self.transitionDelegate?.slideToDismissEnabled = false
        ctr.transitioningDelegate = self.transitionDelegate
        self.presentViewController(ctr, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func likeButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

//MARK: - Private methods
extension CouponViewController {
    
    private func setupImageSlideShow() {
        let alamofireSource = [AlamofireSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!,
                               AlamofireSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!,
                               AlamofireSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
        imageSlideshow.backgroundColor = UIColor.lightGrayColor()
//        imageSlideshow.slideshowInterval = 2.0
        imageSlideshow.pageControlPosition = PageControlPosition.UnderScrollView
        imageSlideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGrayColor()
        imageSlideshow.pageControl.pageIndicatorTintColor = UIColor.blackColor()
        imageSlideshow.contentScaleMode = .ScaleToFill
        imageSlideshow.pageControlPosition = .InsideScrollView
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(CouponViewController.clickOnImageSlideShow))
        imageSlideshow.addGestureRecognizer(recognizer)
        imageSlideshow.setImageInputs(alamofireSource)
    }
    
}

extension CouponViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.point = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            return
        }
        if scrollView.contentOffset.y < self.point.y {
            self.backButton.hidden = false
        }else {
            self.backButton.hidden = true
        }
    }
}
