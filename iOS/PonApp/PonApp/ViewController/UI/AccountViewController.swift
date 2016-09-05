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
}

extension AccountViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell?
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
}

extension AccountViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}