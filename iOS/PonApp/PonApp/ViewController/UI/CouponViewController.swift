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
    @IBOutlet weak var qrCodeButton: UIButton!
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var couponInfoLabel: UILabel!
    @IBOutlet weak var similarCouponCollectionView: UICollectionView!
    
    var transitionDelegate: ZoomAnimatedTransitioningDelegate?
    var point: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let text = "説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります説明が入りま す説明が入ります..説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります..説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります説明が入ります.."
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
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.backButton.setImage(UIImage(named: "nav_back"), forState: .Normal)
        self.shareButton.setImage(UIImage(named: "coupon_button_share"), forState: .Normal)
        self.likeButton.setImage(UIImage(named: "coupon_button_like"), forState: .Normal)
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        similarCouponCollectionView.registerNib(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
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
        let vc = ShareCouponViewController.instanceFromStoryBoard("Coupon")
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func likeButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction override func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func qrCodeButtonPressed(sender: AnyObject) {
        let vc = ScanQRCodeViewController.instanceFromStoryBoard("Coupon")
        self.navigationController?.pushViewController(vc, animated: false)
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

//MARK: UIScrollViewDelegate
extension CouponViewController: UIScrollViewDelegate {
    
}

//MARK: - UICollectionViewDataSource
extension CouponViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CouponCollectionViewCell", forIndexPath: indexPath) as! CouponCollectionViewCell
        cell.coupon = Coupon.init()
        return cell
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let commentView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CouponCollectionViewCell", forIndexPath: indexPath) as! CouponCollectionViewCell
        return commentView
    }
    
}

//MARK: - UICollectionViewDelegate
extension CouponViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = CouponViewController.instanceFromStoryBoard("Coupon")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CouponViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let picDimension = (self.view.frame.size.width - 30) / 2.0
        return CGSizeMake(picDimension, 185)
    }
    
}
