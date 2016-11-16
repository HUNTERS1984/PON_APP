//
//  FavoriteViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/2/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class FavoriteViewController: BaseViewController {

    @IBOutlet weak var tabFavoriteButton: UIButton!
    @IBOutlet weak var tabPonButton: UIButton!
    @IBOutlet weak var tabAccountButton: UIButton!
    @IBOutlet weak var collectionView:UICollectionView!
    
    var coupons = [Coupon]()
    var previousSelectedIndexPath: IndexPath? = nil
    
    //paging
    var canLoadMore: Bool = true
    var currentPage: Int = 1
    var totalPage: Int!
    var nextPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "お気に入り"
        
        let button = UIBarButtonItem(image: UIImage(named: "nav_add"), style: .plain, target: self, action: #selector(self.navAddButtonPressed(_: )))
        self.navigationItem.leftBarButtonItem = button
        self.tabFavoriteButton.setImage(UIImage(named: "tabbar_favorite_selected"), for: UIControlState())
        self.tabPonButton.setImage(UIImage(named: "tabbar_pon"), for: UIControlState())
        self.tabAccountButton.setImage(UIImage(named: "tabbar_account_normal"), for: UIControlState())
        
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        collectionView.register(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
        self.registerNotification()
        
        self.loadFavoriteCoupon(self.currentPage)
    }
    
    override func setUpComponentsOnWillAppear() {
        super.setUpComponentsOnWillAppear()
    }
    
}

//MARK: - IBAction
extension FavoriteViewController {
    
    @IBAction func favoriteButtonPressed(_ sender: AnyObject) {
    }
    
    @IBAction func homeButtonPressed(_ sender: AnyObject) {
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func accountButtonPressed(_ sender: AnyObject) {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func navAddButtonPressed(_ sender: AnyObject) {

    }
    
}

//MARK: - Private
extension FavoriteViewController {
    
    fileprivate func loadFavoriteCoupon(_ pageIndex: Int) {
        self.showHUD()
        ApiRequest.getFavoriteCoupon(pageIndex: pageIndex) {(request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    self.nextPage = result!.nextPage
                    self.totalPage = result!.totalPage
                    self.currentPage = result!.currentPage
                    
                    var responseCoupon = [Coupon]()
                    let couponsArray = result?.data?.array
                    if let _ = couponsArray {
                        for couponData in couponsArray! {
                            let coupon = Coupon(response: couponData)
                            responseCoupon.append(coupon)
                        }
                        if pageIndex == 1 {
                            self.displayCoupon(responseCoupon, type: .new)
                        }else {
                            self.canLoadMore = true
                            self.displayCoupon(responseCoupon, type: .loadMore)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func displayCoupon(_ coupons: [Coupon], type: GetType) {
        switch type {
        case .new:
            self.coupons.removeAll()
            self.coupons = coupons
            self.collectionView.reloadData()
            break
        case .loadMore:
            self.coupons.append(contentsOf: coupons)
            self.collectionView.reloadData()
            break
        case .reload:
            break
        }
    }
    
    fileprivate func getCouponDetail(_ couponId: Float) {
        self.showHUD()
        ApiRequest.getCouponDetail(couponId, hasAuth: UserDataManager.isLoggedIn()) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    let coupon = Coupon(response: result?.data)
                    let vc = CouponViewController.instanceFromStoryBoard("Coupon") as! CouponViewController
                    vc.coupon = coupon
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
    fileprivate func resetCollectionView() {
        if let _ = self.previousSelectedIndexPath {
            self.coupons[(self.previousSelectedIndexPath! as NSIndexPath).item].showConfirmView = false
            collectionView.reloadItems(at: [self.previousSelectedIndexPath!])
            self.previousSelectedIndexPath = nil
        }
    }
    
    fileprivate func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.processLikeCouponNotification), name: Notification.Name(LikeCouponNotification), object: nil)
    }
    
    @objc fileprivate func processLikeCouponNotification() {
        self.loadFavoriteCoupon(1)
    }
    
}

//MARK: - UICollectionViewDataSource
extension FavoriteViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCollectionViewCell", for: indexPath) as! CouponCollectionViewCell
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        let couponTest = self.coupons[(indexPath as NSIndexPath).item]
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async(execute: { 
                cell.coupon = couponTest
            })
        }
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
extension FavoriteViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCoupon = self.coupons[indexPath.item]
        if let _ = selectedCoupon.needLogin {
            if selectedCoupon.needLogin! {
                if UserDataManager.isLoggedIn() {
                    self.resetCollectionView()
                    self.getCouponDetail(selectedCoupon.couponID)
                }else {
                    if let _ = self.previousSelectedIndexPath {
                        if indexPath == self.previousSelectedIndexPath! {
                            return
                        }
                        self.coupons[self.previousSelectedIndexPath!.item].showConfirmView = false
                        collectionView.reloadItems(at: [self.previousSelectedIndexPath!])
                        
                        self.coupons[indexPath.item].showConfirmView = true
                        collectionView.reloadItems(at: [indexPath])
                        self.previousSelectedIndexPath = indexPath
                    }else {
                        self.coupons[indexPath.item].showConfirmView = true
                        collectionView.reloadItems(at: [indexPath])
                        self.previousSelectedIndexPath = indexPath
                    }
                }
            }else {
                self.resetCollectionView()
                self.getCouponDetail(selectedCoupon.couponID)
            }
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenHeight = UIScreen.main.bounds.height
        let width = (self.view.frame.size.width - 22) / 2.0
        let height = screenHeight * (188/667)
        return CGSize(width: width, height: height)
    }
    
}

//MARK: - UIScrollViewDelegate
extension FavoriteViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.currentPage == self.totalPage {
            return
        }
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && canLoadMore {
            canLoadMore = false
            self.loadFavoriteCoupon(self.nextPage)
        }
    }
    
}
