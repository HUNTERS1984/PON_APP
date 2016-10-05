//
//  HomeSearchViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class HomeSearchViewController: BaseViewController {

    @IBOutlet weak var couponTypeTableView: UITableView!
    
    var couponTypes = [Category]() {
        didSet {
            self.couponTypeTableView.reloadData()
            if couponTypes.count > 0 {
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
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "nav_search"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.showSearchBox()
        self.showRightBarButtonWithTitle("キャンセル")
        self.couponTypeTableView.isHidden = true
        self.getCouponType(1)
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
        searchBox.font = UIFont.HiraginoSansW6(17)
        searchBox.placeholder = "地名/ショップ名を入力"
        searchBox.attributedPlaceholder = NSAttributedString(string:"地名/ショップ名を入力", attributes:[NSForegroundColorAttributeName: UIColor.white])
        searchBox.borderStyle = .none
        searchBox.autoresizingMask = .flexibleWidth

        
        let leftNegativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftNegativeSpacer.width = -6
        self.navigationItem.titleView = searchBox
    }
    
    fileprivate func getCouponType(_ pageIndex: Int) {
        self.showHUD()
        ApiRequest.getCouponCategory(pageIndex: 1) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    var responseCategory = [Category]()
                    let categoryArray = result?.data?.array
                    if let _ = categoryArray {
                        for categoryData in categoryArray! {
                            let category = Category(response: categoryData)
                            responseCategory.append(category)
                        }
                        self.couponTypes = responseCategory
                    }
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
}

extension HomeSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.couponTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponTypeTableViewCell") as! CouponTypeTableViewCell
        cell.setDataForCell(self.couponTypes[(indexPath as NSIndexPath).row])
        return cell
    }
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
}

extension HomeSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedType = self.couponTypes[(indexPath as NSIndexPath).row]
        let vc = ListCouponViewController.instanceFromStoryBoard("CouponList") as! ListCouponViewController
        vc.couponCategoryID = selectedType.categoryID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
