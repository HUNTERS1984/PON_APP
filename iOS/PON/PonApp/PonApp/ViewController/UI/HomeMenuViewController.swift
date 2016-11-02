//
//  HomeMenuViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/6/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class HomeMenuViewController: BaseViewController {

    @IBOutlet weak var categoryTableView: UITableView!
    
    var categories = [Category]()
    
    //paging
    var canLoadMore: Bool = true
    var currentPage: Int = 1
    var totalPage: Int!
    var nextPage: Int!
    
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
        self.categoryTableView.tableFooterView = UIView()
        self.getNumberOfShopByCouponType(currentPage)
    }

}

//MARK: - Private

extension HomeMenuViewController {
    
    fileprivate func getNumberOfShopByCouponType(_ pageIndex: Int) {
        self.showHUD()
        ApiRequest.getNumberOfShopByCategory(pageIndex: pageIndex) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    self.nextPage = result!.nextPage
                    self.totalPage = result!.totalPage
                    self.currentPage = result!.currentPage
                    
                    var categoryType = [Category]()
                    let categoryArray = result?.data?.array
                    if let _ = categoryArray {
                        for category in categoryArray! {
                            let couponType = Category(response: category)
                            categoryType.append(couponType)
                        }
                        if pageIndex == 1 {
                            self.displayCategory(categoryType, type: .new)
                        }else {
                            self.canLoadMore = true
                            self.displayCategory(categoryType, type: .loadMore)
                        }
                    }
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
    fileprivate func displayCategory(_ categories: [Category], type: GetType) {
        switch type {
        case .new:
            self.categories.removeAll()
            self.categories = categories
            self.categoryTableView.reloadData()
            break
        case .loadMore:
            self.categories.append(contentsOf: categories)
            self.categoryTableView.reloadData()
            break
        case .reload:
            break
        }
    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCountTableViewCell") as! ShopCountTableViewCell
        cell.setDataForCell(self.categories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedType = self.categories[(indexPath as NSIndexPath).row]
        let vc = ListShopViewController.instanceFromStoryBoard("ListShop") as! ListShopViewController
        vc.couponCategoryID = selectedType.categoryID
        vc.categoryName = selectedType.categoryName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - UIScrollViewDelegate
extension HomeMenuViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.currentPage == self.totalPage {
            return
        }
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && canLoadMore {
            canLoadMore = false
            self.getNumberOfShopByCouponType(self.nextPage)
        }
    }
    
}
