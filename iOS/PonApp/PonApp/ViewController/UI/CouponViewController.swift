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
    @IBOutlet weak var albumCollectionView: AlbumCollectionView!
    @IBOutlet weak var albumCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var similarCouponCollectionView: UICollectionView!
    @IBOutlet weak var similarCouponCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var couponTitleLabel: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var shopAvatarImageView: DesignableImageView!
    @IBOutlet weak var shopAddressLabel: UILabel!
    @IBOutlet weak var shopBusinessHoursLabel: UILabel!
    @IBOutlet weak var shopPhoneNumber: UILabel!
    
    var transitionDelegate: ZoomAnimatedTransitioningDelegate?
    var similarCoupon = [Coupon]() {
        didSet {
            if self.similarCoupon.count > 0 {
                self.similarCouponCollectionView.reloadData {
                    self.similarCouponCollectionViewConstraint.constant = self.similarCouponCollectionView.contentSize.height
                }
            }else {
                self.similarCouponCollectionView.reloadData {
                    self.similarCouponCollectionViewConstraint.constant = 0
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.backButton.setImage(UIImage(named: "nav_back"), forState: .Normal)
        self.shareButton.setImage(UIImage(named: "coupon_button_share"), forState: .Normal)
        self.likeButton.setImage(UIImage(named: "coupon_button_like"), forState: .Normal)
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        similarCouponCollectionView.registerNib(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
        
        self.getCouponDetail(1)
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
    
    private func setupImageSlideShow(urls: [String]) {
        var alamofireSource = [AlamofireSource]()
        for url in urls {
            alamofireSource.append(AlamofireSource(urlString: url)!)
        }
        imageSlideshow.backgroundColor = UIColor.lightGrayColor()
        imageSlideshow.pageControlPosition = PageControlPosition.UnderScrollView
        imageSlideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGrayColor()
        imageSlideshow.pageControl.pageIndicatorTintColor = UIColor.blackColor()
        imageSlideshow.contentScaleMode = .ScaleToFill
        imageSlideshow.pageControlPosition = .InsideScrollView
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(CouponViewController.clickOnImageSlideShow))
        imageSlideshow.addGestureRecognizer(recognizer)
        imageSlideshow.setImageInputs(alamofireSource)
    }
    
    private func setupPhotoCollectionView(urls: [String]) {
        self.albumCollectionView.photos = urls
        self.albumCollectionView.reloadData {
            self.albumCollectionViewConstraint.constant = self.albumCollectionView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    private func getCouponDetail(couponId: Int) {
        self.showHUD()
        ApiRequest.getCouponDetail(couponId) { (request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                let coupon = Coupon(response: result?.data)
                self.displayCouponDetail(coupon)
            }
        }
    }
    
    private func displayCouponDetail(coupon: Coupon) {
        self.couponInfoLabel.text = coupon.description
        if coupon.isLike! {
            self.likeButton.setImage(UIImage(named: "coupon_button_liked"), forState: .Normal)
        }else {
            self.likeButton.setImage(UIImage(named: "coupon_button_like"), forState: .Normal)
        }
        self.setupImageSlideShow(coupon.couponPhotosUrl)
        self.couponTitleLabel.text = coupon.title
        self.expiryLabel.text = coupon.expiryDate
        self.shopAvatarImageView.af_setImageWithURL(NSURL(string: coupon.shopAvatarUrl)!)
        self.shopAddressLabel.text = coupon.shopAddress
        self.shopBusinessHoursLabel.text = coupon.shopBusinessHours
        self.shopPhoneNumber.text = coupon.shopPhonenumber
        self.setupPhotoCollectionView(coupon.userPhotosUrl)
        self.similarCoupon = coupon.similarCoupons
    }
    
}

//MARK: UIScrollViewDelegate
extension CouponViewController: UIScrollViewDelegate {
    
}

//MARK: - UICollectionViewDataSource
extension CouponViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.similarCoupon.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CouponCollectionViewCell", forIndexPath: indexPath) as! CouponCollectionViewCell
        cell.coupon = self.similarCoupon[indexPath.item]
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
        let screenHeight = UIScreen.mainScreen().bounds.height
        let width = (self.view.frame.size.width - 30) / 2.0
        let height = screenHeight * (189/667)
        return CGSizeMake(width, height)
    }
    
}
