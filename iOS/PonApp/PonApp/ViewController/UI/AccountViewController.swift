//
//  AccountViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/2/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class AccountViewController: BaseViewController {

    @IBOutlet weak var recentTableView: UITableView!
    
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var tabFavoriteButton: UIButton!
    @IBOutlet weak var tabPonButton: UIButton!
    @IBOutlet weak var tabAccountButton: UIButton!
    
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
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.settingButton.setImage(UIImage(named: "account_setting_button"), forState: .Normal)
        self.tabFavoriteButton.setImage(UIImage(named: "tabbar_favorite_normal"), forState: .Normal)
        self.tabPonButton.setImage(UIImage(named: "tabbar_pon"), forState: .Normal)
        self.tabAccountButton.setImage(UIImage(named: "tabbar_account_selected"), forState: .Normal)
    }
    
}

//MARK: - IBAction
extension AccountViewController {
    
    @IBAction func favoriteButtonPressed(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func homeButtonPressed(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func accountButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func settingButtonPressed(sender: AnyObject) {
        let vc = EditAccountViewController.instanceFromStoryBoard("Account")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func followedShopButtonPressed(sender: AnyObject) {
        let vc = ShopFollowViewController.instanceFromStoryBoard("Follow")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func historyButtonPressed(sender: AnyObject) {
        let vc = HistoryViewController.instanceFromStoryBoard("Account")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func newsButtonPressed(sender: AnyObject) {
        let vc = NewsViewController.instanceFromStoryBoard("Account")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Private
extension AccountViewController {
    
    private func getListFunction() -> [String] {
        return [
            "利用規約",//terms of service
            "プライバシーポリシー",//privacy policy
            "特定商取引",//specified trade
            "お問い合わせ",//contact us
            "掲載希望のショップ様"//news
        ]
    }
    
}


//MARK: - UITableViewDataSource
extension AccountViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getListFunction().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountTableViewCell") as! AccountTableViewCell
        cell.titleLabel.text = self.getListFunction()[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let screenHeight = UIScreen.mainScreen().bounds.height
        return screenHeight * (60/667)
    }
    
}

//MARK: - UITableViewDelegate
extension AccountViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        switch indexPath.row {
        case 0:
            let vc = TermsOfServiceViewController.instanceFromStoryBoard("Account")
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 1:
            let vc = PrivacyPolicyViewController.instanceFromStoryBoard("Account")
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 2:
            let vc = SpecifiedTradeViewController.instanceFromStoryBoard("Account")
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 3:
            break;
        case 4:
            break;
        default:
            break;
        }
    }
}