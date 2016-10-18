//
//  MainCouponContentViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/28/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class MainCouponContentViewController: BaseViewController {
    
    var parentNavigationController : UINavigationController?
    var parentContainerController : BaseViewController?
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var contentTableViewHeight: NSLayoutConstraint!
    
    var couponFeature:CouponFeature?
    var couponListData = [CouponListData]()
    var previousCollectionView: HorizontalCollectionView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        let myCellNib = UINib(nibName: "CouponCollectionTableViewCell", bundle: nil)
        contentTableView.register(myCellNib, forCellReuseIdentifier: "CouponCollectionTableViewCell")
        self.contentTableView.isScrollEnabled = false
        self.contentTableView.allowsSelection = false
        self.contentTableView.separatorStyle = .none
        self.getCouponByFeature(self.couponFeature!, pageIndex: 1)
    }
    
}

//MARK: - Private
extension MainCouponContentViewController {
    
    fileprivate func getCouponDetail(_ couponId: Float) {
        parentContainerController?.showHUD()
        ApiRequest.getCouponDetail(couponId, hasAuth: UserDataManager.isLoggedIn()) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.parentContainerController?.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    let coupon = Coupon(response: result?.data)
                    let vc = CouponViewController.instanceFromStoryBoard("Coupon") as! CouponViewController
                    vc.coupon = coupon
                    self.parentNavigationController?.pushViewController(vc, animated: true)
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
    fileprivate func showMoreCouponViewController(_ categoryID: Float) {
        let vc = ListCouponViewController.instanceFromStoryBoard("CouponList") as! ListCouponViewController
        vc.couponCategoryID = Int(categoryID)
        self.parentNavigationController!.pushViewController(vc, animated: true)
    }
    
}

//MARK: - UITableViewDataSource
extension MainCouponContentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCollectionTableViewCell", for: indexPath) as! CouponCollectionTableViewCell
        cell.moreButtonCallback = {(sender, categoryId) -> Void in
            self.showMoreCouponViewController(categoryId)
        }
        return cell
    }
    
    @objc(tableView:willDisplayCell:forRowAtIndexPath:) func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let collectionCell = cell as! CouponCollectionTableViewCell
        collectionCell.couponCollectionView.index = (indexPath as NSIndexPath).row
        collectionCell.setCollectionViewDelegate(delegate: self, index: (indexPath as NSIndexPath).row, couponListData: self.couponListData[(indexPath as NSIndexPath).row])
    }
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let height = screenHeight * (234/667)
        return height
    }
    
}

//MARK: - UITableViewDelegate
extension MainCouponContentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension MainCouponContentViewController: HorizontalCollectionViewDelegate {
    
    func horizontalCollectionView(_ collectionView: HorizontalCollectionView, didSelectCoupon coupon: Coupon?, atIndexPath indexPath: IndexPath) {
        if let _ = self.previousCollectionView {
            if self.previousCollectionView! != collectionView {
                self.previousCollectionView!.resetCollectionView()
            }
        }
        self.previousCollectionView = collectionView
        if let _ = coupon {
            self.getCouponDetail(coupon!.couponID)
        }
    }
    
    func horizontalCollectionView(_ collectionView: HorizontalCollectionView, didPressSignUpButton button: AnyObject?) {
        collectionView.resetCollectionView()
        self.openSignUp()
    }
    
}

//MARK: - Private
extension MainCouponContentViewController {
    
    fileprivate func openSignUp() {
        let vc = SignInViewController.instanceFromStoryBoard("Register")
        let nav = UINavigationController.init(rootViewController: vc!)
        self.parentNavigationController!.present(nav, animated: true)
    }
    
    fileprivate func getCouponByFeature(_ couponFeature: CouponFeature, pageIndex: Int) {
        parentContainerController?.showHUD()
        ApiRequest.getCouponByFeature(couponFeature) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.parentContainerController?.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    var responseData = [CouponListData]()
                    let couponsArray = result?.data?.array
                    if let _ = couponsArray {
                        for couponData in couponsArray! {
                            let data = CouponListData(response: couponData)
                            responseData.append(data)
                        }
                        if pageIndex == 1 {
                            self.displayData(responseData, type: .new)
                        }else {
                            self.displayData(responseData, type: .loadMore)
                        }
                    }
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
    fileprivate func displayData(_ data: [CouponListData], type: GetType) {
        switch type {
        case .new:
            self.couponListData.removeAll()
            self.couponListData = data
            self.contentTableView.reloadData {
                let heightConstant = self.contentTableView.contentSize.height
                self.contentTableViewHeight.constant = heightConstant;
            }
            break
        case .loadMore:
            self.couponListData.append(contentsOf: data)
            self.contentTableView.reloadData {
                let heightConstant = self.contentTableView.contentSize.height
                self.contentTableViewHeight.constant = heightConstant;
            }
            break
        case .reload:
            break
        }
    }
    
}
