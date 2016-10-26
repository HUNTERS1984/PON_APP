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
    @IBOutlet weak var avatarImageView: CircleImageView!
    @IBOutlet weak var usernamLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerProcessNotification()
        self.processRemoteNotificationLauchApp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.settingButton.setImage(UIImage(named: "account_setting_button"), for: UIControlState())
        self.tabFavoriteButton.setImage(UIImage(named: "tabbar_favorite_normal"), for: UIControlState())
        self.tabPonButton.setImage(UIImage(named: "tabbar_pon"), for: UIControlState())
        self.tabAccountButton.setImage(UIImage(named: "tabbar_account_selected"), for: UIControlState())
    }
    
    override func setUpComponentsOnWillAppear() {
        super.setUpComponentsOnWillAppear()
        self.displayUserInfo()
    }
    
}

//MARK: - IBAction
extension AccountViewController {
    
    @IBAction func favoriteButtonPressed(_ sender: AnyObject) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func homeButtonPressed(_ sender: AnyObject) {
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func accountButtonPressed(_ sender: AnyObject) {
    }
    
    @IBAction func settingButtonPressed(_ sender: AnyObject) {
        let vc = EditAccountViewController.instanceFromStoryBoard("Account")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func followedShopButtonPressed(_ sender: AnyObject) {
        let vc = ShopFollowViewController.instanceFromStoryBoard("Follow")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func historyButtonPressed(_ sender: AnyObject) {
        let vc = HistoryViewController.instanceFromStoryBoard("Account")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func newsButtonPressed(_ sender: AnyObject) {
        let vc = NewsViewController.instanceFromStoryBoard("Account")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

//MARK: - Private
extension AccountViewController {
    
    fileprivate func getListFunction() -> [String] {
        return [
            "利用規約",//terms of service
            "プライバシーポリシー",//privacy policy
            "特定商取引",//specified trade
            "お問い合わせ",//contact us
            "掲載希望のショップ様"//news
        ]
    }
    
    fileprivate func getUserProfile() {
        self.showHUD()
        ApiRequest.getUserProfile { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
        }
    }
    
    fileprivate func displayUserInfo() {
        if let _ = UserDataManager.sharedInstance.username {
            self.usernamLabel.text = UserDataManager.sharedInstance.username!
        }else {
            self.usernamLabel.text = ""
        }
        
        if let _ = UserDataManager.sharedInstance.avatarUrl {
            let avatarUrl = URL(string: UserDataManager.sharedInstance.avatarUrl!)
            self.avatarImageView.af_setImage(withURL: avatarUrl!)
        }else {
            self.avatarImageView.image = UIImage(named: "account_avatar_placehoder")
        }
    }
    
}


//MARK: - UITableViewDataSource
extension AccountViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getListFunction().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell") as! AccountTableViewCell
        cell.titleLabel.text = self.getListFunction()[(indexPath as NSIndexPath).row]
        return cell
    }

    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight * (60/667)
    }
    
}

//MARK: - UITableViewDelegate
extension AccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch (indexPath as NSIndexPath).row {
        case 0:
            let vc = TermsOfServiceViewController.instanceFromStoryBoard("Account")
            self.navigationController?.pushViewController(vc!, animated: true)
            break;
        case 1:
            let vc = PrivacyPolicyViewController.instanceFromStoryBoard("Account")
            self.navigationController?.pushViewController(vc!, animated: true)
            break;
        case 2:
            let vc = SpecifiedTradeViewController.instanceFromStoryBoard("Account")
            self.navigationController?.pushViewController(vc!, animated: true)
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