//
//  CouponViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/6/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

protocol CouponViewControllerDelegate: class {
    func couponViewController(_ viewController: CouponViewController, didUpdateLikeCouponStatusAtIndex index: Int?, rowIndex: Int?, couponId: Float?, status: Bool)
}

class CouponViewController: BaseViewController {
    
    weak var handler: CouponViewControllerDelegate? = nil
    
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var qrCodeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var useCouponButton: UIButton!
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var couponInfoLabel: PaddingLabel!
    @IBOutlet weak var couponTypeLabel: UILabel!
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
    @IBOutlet weak var detailMapView: MapView!
    @IBOutlet weak var couponCategoryLabel: UILabel!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var requestUseCouponButtonConstrait: NSLayoutConstraint!
    
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
    var coupon: Coupon? = nil
    var selectedCouponIndex: Int?
    var selectedRowIndex: Int?
    var confirmPopup: RequestCouponPopupView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }

    override func startGoogleAnalytics() {
        super.startGoogleAnalytics()
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: GAScreen_CouponDetail)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.qrCodeButton.setImage(UIImage(named: "coupon_qr_code"), for: UIControlState())
        self.backButton.setImage(UIImage(named: "nav_back"), for: UIControlState())
        self.shareButton.setImage(UIImage(named: "coupon_button_share"), for: UIControlState())
        self.likeButton.setImage(UIImage(named: "coupon_button_like"), for: UIControlState())
        self.albumCollectionView.handler = self
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        similarCouponCollectionView.register(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
        self.requestUseCouponButtonConstrait.constant = 0
        self.setupConfirmPopupView()
        if let _ = self.coupon {
            self.displayCouponDetail(self.coupon!)
        }
    }
}

//MARK: - IBAction
extension CouponViewController {
    
    func clickOnImageSlideShow() {
        let ctr = FullScreenSlideshowViewController()
        ctr.pageSelected = {(page: Int) in
            self.imageSlideshow.setScrollViewPage(scrollViewPage: page, animated: false)
        }
        
        ctr.initialImageIndex = imageSlideshow.scrollViewPage
        ctr.inputs = imageSlideshow.images
        self.transitionDelegate = ZoomAnimatedTransitioningDelegate(slideshowView: imageSlideshow, slideshowController: ctr)
        // Uncomment if you want disable the slide-to-dismiss feature
        // self.transitionDelegate?.slideToDismissEnabled = false
        ctr.transitioningDelegate = self.transitionDelegate
        self.present(ctr, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        let vc = ShareCouponViewController.instanceFromStoryBoard("Coupon") as! ShareCouponViewController
        vc.code = coupon?.code
        vc.coupon = self.coupon
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func likeButtonPressed(_ sender: AnyObject) {
        if UserDataManager.isLoggedIn() {
            if self.coupon!.isLike! {
                self.unLikeCoupon()
                
            }else {
                self.likeCoupon()
            }
        }else {
            self.presentAlert(message: UserNotLoggedIn)
        }
    }
    
    @IBAction override func backButtonPressed(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func useCouponButtonPressed(_ sender: AnyObject) {
        /*
        if UserDataManager.isLoggedIn() {
            if let _ = self.coupon?.code {
                let vc = ShowQRCodeViewController.instanceFromStoryBoard("Coupon") as! ShowQRCodeViewController
                vc.code = coupon?.code
                self.navigationController?.present(vc, animated: true)
            }else {
                self.presentAlert(message: QRCodeUnavailable)
            }
        }else {
            self.presentAlert(message: UserNotLoggedIn)
        }
         */
        self.confirmPopup.showPopup(inView: self.view, animated: true)
    }
    
    @IBAction func qrCodeButtonPressed(_ sender: AnyObject) {
        if UserDataManager.isLoggedIn() {
            if let _ = self.coupon?.code {
                let vc = ShowQRCodeViewController.instanceFromStoryBoard("Coupon") as! ShowQRCodeViewController
                vc.code = coupon?.code
                self.navigationController?.present(vc, animated: true)
            }else {
                self.presentAlert(message: QRCodeUnavailable)
            }
        }else {
            self.presentAlert(message: UserNotLoggedIn)
        }
    }
    
}

//MARK: - Private methods
extension CouponViewController {
    
    fileprivate func likeCoupon() {
        UIAlertController.present(title: "", message: LikeCouponConfirmation, actionTitles: [OK, Cancel]) { (action) -> () in
            if action.title == "OK" {
                self.showHUD()
                ApiRequest.likeCoupon(self.coupon!.couponID) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
                    self.hideHUD()
                    if let _ = error {
                        
                    }else {
                        if result!.code == SuccessCode {
                            self.coupon!.isLike = true
                            self.likeButton.setImage(UIImage(named: "coupon_button_liked"), for: .normal)
                            self.updateLikeCouponStatus(true)
                        }else {
                            self.presentAlert(message: (result?.message)!)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func unLikeCoupon() {
        UIAlertController.present(title: "", message: UnLikeCouponConfirmation, actionTitles: [OK, Cancel]) { (action) -> () in
            if action.title == "OK" {
                self.showHUD()
                ApiRequest.unLikeCoupon(self.coupon!.couponID) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
                    self.hideHUD()
                    if let _ = error {
                        
                    }else {
                        if result!.code == SuccessCode {
                            self.coupon!.isLike = false
                            self.likeButton.setImage(UIImage(named: "coupon_button_like"), for: .normal)
                            self.updateLikeCouponStatus(false)
                        }else {
                            self.presentAlert(message: (result?.message)!)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func setupImageSlideShow(_ urls: [String]) {
        var alamofireSource = [AlamofireSource]()
        if urls.count > 5 {
            for i in 0..<5 {
                alamofireSource.append(AlamofireSource(urlString: urls[i])!)
            }
        }else {
            for url in urls {
                alamofireSource.append(AlamofireSource(urlString: url)!)
            }
        }
        
        imageSlideshow.backgroundColor = UIColor.lightGray
        imageSlideshow.pageControl.currentPageIndicatorTintColor = UIColor(hex: 0x18c0d4)
        imageSlideshow.pageControl.pageIndicatorTintColor = UIColor.white
        imageSlideshow.contentScaleMode = .scaleToFill
        imageSlideshow.pageControlPosition = .InsideScrollView
        //let recognizer = UITapGestureRecognizer(target: self, action: #selector(CouponViewController.clickOnImageSlideShow))
        //imageSlideshow.addGestureRecognizer(recognizer)
        imageSlideshow.setImageInputs(inputs: alamofireSource)
    }
    
    fileprivate func setupPhotoCollectionView(_ urls: [String]) {
        self.albumCollectionView.photos = urls
        self.albumCollectionView.reloadData {
            self.albumCollectionViewConstraint.constant = self.albumCollectionView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func getCouponDetail(_ couponId: Float) {
        self.showHUD()
        ApiRequest.getCouponDetail(couponId, hasAuth: UserDataManager.isLoggedIn()) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                let coupon = Coupon(response: result?.data)
                self.displayCouponDetail(coupon)
            }
        }
    }
    
    fileprivate func displayCouponDetail(_ coupon: Coupon) {
        self.containerScrollView.scrollToTop()
        self.couponCategoryLabel.text = coupon.category!
        self.categoryIcon.af_setImage(withURL: URL(string: coupon.categoryIcon)!)
        self.couponInfoLabel.text = coupon.description!
        self.couponInfoLabel.setLineHeight(lineHeight: 1.75)
        self.couponTypeLabel.text = "\(coupon.couponType!)・ID \(coupon.maskCouponId!)"
        if coupon.isLike! {
            self.likeButton.setImage(UIImage(named: "coupon_button_liked"), for: UIControlState())
        }else {
            self.likeButton.setImage(UIImage(named: "coupon_button_like"), for: UIControlState())
        }
        self.detailMapView.createShopMarker(coupon.shopCoordinate)
        self.setupImageSlideShow(coupon.couponPhotosUrl)
        self.couponTitleLabel.text = coupon.title
        self.expiryLabel.text = coupon.expiryDate
        self.shopAvatarImageView.af_setImage(withURL: URL(string: coupon.shopAvatarUrl)!)
        self.shopAddressLabel.text = coupon.shopAddress
        self.shopBusinessHoursLabel.text = "\(coupon.shopStartTime!)~\(coupon.shopEndTime!)"
        self.shopPhoneNumber.text = coupon.shopPhonenumber
        self.setupPhotoCollectionView(coupon.userPhotosUrl)
        self.similarCoupon = coupon.similarCoupons
        if coupon.canUse! {
            self.requestUseCouponButtonConstrait.constant = 45
        }
    }
    
    fileprivate func updateLikeCouponStatus(_ isLiked: Bool) {
        self.handler?.couponViewController(self, didUpdateLikeCouponStatusAtIndex: self.selectedCouponIndex, rowIndex: self.selectedRowIndex, couponId: self.coupon!.couponID, status: isLiked)
        
        var userInfo = [String: Any]()
        userInfo["coupon_id"] = self.coupon!.couponID
        if let _ = self.selectedCouponIndex{
            userInfo["coupon_index"] = self.selectedCouponIndex!
        }
        if  let _ = self.selectedRowIndex {
            userInfo["row_index"] = self.selectedRowIndex!
        }
        
        userInfo["is_liked"] = isLiked
        NotificationCenter.default.post(name:Notification.Name(LikeCouponNotification),
                                        object: nil,
                                        userInfo:userInfo)
    }
    
    fileprivate func requestUseCoupon() {
        self.showHUD()
        ApiRequest.requestUseCoupon(self.coupon!.code!) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    self.presentAlert(message: result!.message)
                }
            }
        }
    }
    
    func setupConfirmPopupView() {
        confirmPopup = RequestCouponPopupView.create()
        confirmPopup.coupon = self.coupon
        confirmPopup.doneButtonPressed = { [weak self] in
            self?.confirmPopup.hidePopup()
            self?.requestUseCoupon()
        }
    }
    
}

//MARK: UIScrollViewDelegate
extension CouponViewController: UIScrollViewDelegate {
    
}

//MARK: - UICollectionViewDataSource
extension CouponViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.similarCoupon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCollectionViewCell", for: indexPath) as! CouponCollectionViewCell
        cell.coupon = self.similarCoupon[indexPath.item]
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CouponCollectionViewCell", for: indexPath) as! CouponCollectionViewCell
        return commentView
    }
    
}

//MARK: - UICollectionViewDelegate
extension CouponViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCoupon = coupon!.similarCoupons[indexPath.item];
        self.getCouponDetail(selectedCoupon.couponID)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CouponViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenHeight = UIScreen.main.bounds.height
        let width = (self.view.frame.size.width - 42) / 2.0
        let height = screenHeight * (189/667)
        return CGSize(width: width, height: height)
    }
    
}

//MARK: - AlbumCollectionViewDelegate

extension CouponViewController: AlbumCollectionViewDelegate {
    
    func albumCollectionView(_ collectionView: AlbumCollectionView, didSelectImageAtIndex index: Int, imageUrl url:String) {
        let ctr = PhotoViewerViewController()
        ctr.setImageUrl(url: url)
        self.present(ctr, animated: true)
    }
}
