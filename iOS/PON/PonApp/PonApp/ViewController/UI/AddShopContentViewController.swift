//
//  AddShopContentViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/30/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class AddShopContentViewController: BaseViewController {
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    open weak var parentNavigationController : UINavigationController?
    var couponFeature:CouponFeature?
    var couponType: Int?
    
    var shops = [Shop]()
    
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
        let myCellNib = UINib(nibName: "ShopFollowCollectionViewCell", bundle: nil)
        collectionView.register(myCellNib, forCellWithReuseIdentifier: "ShopFollowCollectionViewCell")
        
        self.getShop(self.couponFeature!, pageIndex: 1)
    }
    
    override func setUpComponentsOnWillAppear() {
        super.setUpComponentsOnWillAppear()
    }
    
}

//MARK: - IBAction
extension AddShopContentViewController {
    
    override func backButtonPressed(_ sender: AnyObject) {
        self.parentNavigationController!.popViewController(animated: true)
    }
    
}

//MARK: - Private
extension AddShopContentViewController {
    
    fileprivate func getShop(_ feature: CouponFeature, pageIndex: Int) {
        if couponFeature == .near {
            self.showHUD()
            LocationManager.sharedInstance.currentLocation { (location: CLLocationCoordinate2D?, error: NSError?) -> () in
                self.hideHUD()
                if let _ = error {
                    
                }else {
                    self.getShopByFeature(feature, longitude: location!.longitude, lattitude: location!.latitude, pageIndex: pageIndex)
                }
            }
        }else {
            self.getShopByFeature(feature, pageIndex: pageIndex)
        }
    }
    
    fileprivate func getShopByFeature(_ feature: CouponFeature, longitude: Double? = nil, lattitude: Double? = nil, pageIndex: Int) {
        self.showHUD()
        ApiRequest.getShopByFeature(feature, hasAuth: UserDataManager.isLoggedIn(), pageIndex: pageIndex) {(request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    var responseShop = [Shop]()
                    let shopArray = result?.data?.array
                    if let _ = shopArray {
                        for shopData in shopArray! {
                            let shop = Shop(response: shopData)
                            responseShop.append(shop)
                        }
                        if pageIndex == 1 {
                            self.displayShop(responseShop, type: .new)
                        }else {
                            self.displayShop(responseShop, type: .loadMore)
                        }
                    }
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
    fileprivate func displayShop(_ shops: [Shop], type: GetType) {
        switch type {
        case .new:
            self.shops.removeAll()
            self.shops = shops
            self.collectionView.reloadData()
            break
        case .loadMore:
            self.shops.append(contentsOf: shops)
            self.collectionView.reloadData()
            break
        case .reload:
            break
        }
    }
    
    fileprivate func getShopDetail(_ shopId: Float) {
        self.showHUD()
        ApiRequest.getShopDetail(shopId) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    let shop = Shop(response: result?.data)
                    let vc = ShopViewController.instanceFromStoryBoard("Shop") as! ShopViewController
                    vc.shop = shop
                    self.parentNavigationController?.pushViewController(vc, animated: true)
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
    fileprivate func followShop(_ shopId: Float, index: Int) {
        if UserDataManager.isLoggedIn() {
            self.showHUD()
            ApiRequest.followShop(shopId) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
                self.hideHUD()
                if let _ = error {
                    
                }else {
                    if result?.code == SuccessCode {
                        self.shops[index].isFollow = true
                        self.collectionView.reloadData()
                        self.presentAlert(with: "Message", message: (result?.message)!)
                    }else {
                        self.presentAlert(message: (result?.message)!)
                    }
                }
            }
        }else {
            self.presentAlert(message: UserNotLoggedIn)
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension AddShopContentViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopFollowCollectionViewCell", for: indexPath) as! ShopFollowCollectionViewCell
        cell.shop = self.shops[indexPath.item]
        cell.index = indexPath.item
        cell.completionHandler = { (shopID: Float?, index: Int) in
            if let _ = shopID {
                if UserDataManager.isLoggedIn() {
                    self.followShop(shopID!, index: index)
                }else {
                    self.presentAlert(message: UserNotLoggedIn)
                }
            }
        }
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ListCouponCollectionViewCell", for: indexPath) as! ListCouponCollectionViewCell
        return commentView
    }
    
}

//MARK: - UICollectionViewDelegate
extension AddShopContentViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedShopId = self.shops[(indexPath as NSIndexPath).item].shopID
        self.getShopDetail(selectedShopId!)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AddShopContentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 22) / 2.0
        let screenSize: CGRect = UIScreen.main.bounds
        return CGSize(width: width, height: screenSize.height * (228/667))
    }
    
}
