//
//  HomeMenuViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/6/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class HomeMenuViewController: BaseViewController {

    @IBOutlet weak var couponTypeTableView: UITableView!
    
    var categories = [Category]() {
        didSet {
            self.couponTypeTableView.reloadData()
            if categories.count > 0 {
                self.couponTypeTableView.isHidden = false
            }else {
                self.couponTypeTableView.isHidden = true
            }
        }
    }
    
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
        self.title = "ショップの追加"
        self.showCloseButton()
        self.couponTypeTableView.isHidden = true
        self.getNumberOfShopByCouponType(1)
    }

}

extension HomeMenuViewController {
    
    fileprivate func getNumberOfShopByCouponType(_ pageIndex: Int) {
        self.showHUD()
        ApiRequest.getNumberOfShopByCategory(pageIndex: 1) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    var responseCouponType = [Category]()
                    let couponTypeArray = result?.data?.array
                    if let _ = couponTypeArray {
                        for couponTypeData in couponTypeArray! {
                            let couponType = Category(response: couponTypeData)
                            responseCouponType.append(couponType)
                        }
                        self.categories = responseCouponType
                    }
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
}

extension HomeMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCountTableViewCell") as! ShopCountTableViewCell
        cell.setDataForCell(self.categories[(indexPath as NSIndexPath).row])
        return cell
    }
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
}

extension HomeMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedType = self.categories[(indexPath as NSIndexPath).row]
        let vc = ListShopViewController.instanceFromStoryBoard("ListShop") as! ListShopViewController
        vc.couponCategoryID = selectedType.categoryID
        vc.categoryName = selectedType.categoryName
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
