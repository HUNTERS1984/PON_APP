//
//  ListShopContentViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/28/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ListShopContentViewController: BaseViewController {
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    var parentNavigationController : UINavigationController?
    var feature:CouponFeature?
    var categoryID: Int?
    
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
        
        self.getShop(self.feature!, category: self.categoryID!, pageIndex: 1)
    }
    
    override func setUpComponentsOnWillAppear() {
        super.setUpComponentsOnWillAppear()
    }
    
}

//MARK: - IBAction
extension ListShopContentViewController {
    
    override func backButtonPressed(_ sender: AnyObject) {
        self.parentNavigationController!.popViewController(animated: true)
    }
    
}

//MARK: - Private
extension ListShopContentViewController {
    
    fileprivate func getShop(_ feature: CouponFeature, category: Int, pageIndex: Int) {
        if feature == .near {
            self.showHUD()
            LocationManager.sharedInstance.currentLocation { (location: CLLocationCoordinate2D?, error: NSError?) -> () in
                self.hideHUD()
                if let _ = error {
                    
                }else {
                    self.getShopByFeatureAndCategory(feature, category:category, longitude: location!.longitude, lattitude: location!.latitude, pageIndex: pageIndex)
                }
            }
        }else {
            self.getShopByFeatureAndCategory(feature, category:category, pageIndex: pageIndex)
        }
    }
    
    fileprivate func getShopByFeatureAndCategory(_ feature: CouponFeature, category: Int, longitude: Double? = nil, lattitude: Double? = nil, pageIndex: Int) {
        self.showHUD()
        ApiRequest.getShopByFeatureAndCategory(feature, category: category, longitude: longitude, lattitude: lattitude, pageIndex: 1) {(request: URLRequest?, result: ApiResponse?, error: NSError?) in
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
                    }else {
                        
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
                let shop = Shop(response: result?.data)
                let vc = ShopViewController.instanceFromStoryBoard("Shop") as! ShopViewController
                vc.shop = shop
                self.parentNavigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    fileprivate func followShop(_ shopId: Float, index: Int) {
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
    }
    
}

//MARK: - UICollectionViewDataSource
extension ListShopContentViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopFollowCollectionViewCell", for: indexPath) as! ShopFollowCollectionViewCell
        cell.shop = self.shops[(indexPath as NSIndexPath).item]
        cell.index = (indexPath as NSIndexPath).item
        cell.completionHandler = { (shopID: Float?, index: Int) in
            if let _ = shopID {
                self.followShop(shopID!, index: index)
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
extension ListShopContentViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedShopId = self.shops[(indexPath as NSIndexPath).item].shopID
        self.getShopDetail(selectedShopId!)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ListShopContentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 22) / 2.0
        let screenSize: CGRect = UIScreen.main.bounds
        return CGSize(width: width, height: screenSize.height * (228/667))
    }
    
}