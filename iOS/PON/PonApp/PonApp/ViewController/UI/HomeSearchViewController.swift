//
//  HomeSearchViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class HomeSearchViewController: BaseViewController {

    @IBOutlet weak var categoryTableView: UITableView!
    
    var categories = [Category]()
    
    //paging
    var canLoadMore: Bool = true
    var currentPage: Int = 1
    var totalPage: Int = 1
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
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "nav_search"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.showSearchBox()
        self.showRightBarButtonWithTitle("キャンセル")
        self.categoryTableView.tableFooterView = UIView()
        self.getCouponCategory(currentPage)
    }

}

//MARK: - IBAction
extension HomeSearchViewController {
    
    @IBAction func locationButtonPressed(_ sender: AnyObject) {
        let vc = HomeMapViewController.instanceFromStoryBoard("MainMenu")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func rightBarButtonPressed(_ sender: AnyObject) {
        super.rightBarButtonPressed(sender)
        self.navigationController!.popViewController(animated: true)
    }
    
}

//MARK: - Private
extension HomeSearchViewController {
    
    fileprivate func showSearchBox() {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        let searchBox = UITextField(frame: CGRect(x: 0, y: 0, width: screenWidth - 60, height: 30))
        searchBox.backgroundColor = UIColor.clear
        searchBox.textColor = UIColor.white
        searchBox.font = UIFont.HiraginoSansW6(14)
        searchBox.placeholder = "地名/ショップ名を入力"
        searchBox.attributedPlaceholder = NSAttributedString(string:"地名/ショップ名を入力", attributes:[NSForegroundColorAttributeName: UIColor(hex: 0xd1f2f6)])
        searchBox.borderStyle = .none
        searchBox.autoresizingMask = .flexibleWidth

        
        let leftNegativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftNegativeSpacer.width = -6
        self.navigationItem.titleView = searchBox
    }
    
    fileprivate func getCouponCategory(_ pageIndex: Int) {
        self.showHUD()
        ApiRequest.getCouponCategory(pageIndex: pageIndex) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    self.nextPage = result!.nextPage
                    self.totalPage = result!.totalPage
                    self.currentPage = result!.currentPage
                    
                    var responseCategory = [Category]()
                    let categoryArray = result?.data?.array
                    if let _ = categoryArray {
                        for categoryData in categoryArray! {
                            let category = Category(response: categoryData)
                            responseCategory.append(category)
                        }
                        if pageIndex == 1 {
                            self.displayCategory(responseCategory, type: .new)
                        }else {
                            self.canLoadMore = true
                            self.displayCategory(responseCategory, type: .loadMore)
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

extension HomeSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponTypeTableViewCell") as! CouponTypeTableViewCell
        cell.setDataForCell(self.categories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedType = self.categories[indexPath.row]
        let vc = ListCouponViewController.instanceFromStoryBoard("CouponList") as! ListCouponViewController
        vc.couponCategoryID = selectedType.categoryID
        vc.categoryName = selectedType.categoryName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - UIScrollViewDelegate
extension HomeSearchViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.currentPage == self.totalPage {
            return
        }
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && canLoadMore {
            canLoadMore = false
            self.getCouponCategory(self.nextPage)
        }
    }
    
}
