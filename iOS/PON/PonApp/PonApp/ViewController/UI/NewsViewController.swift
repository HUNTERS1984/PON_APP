//
//  NewsViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class NewsViewController: BaseViewController {

    @IBOutlet weak var newsTableView: UITableView!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if NotificationManager.shared.isAppResumingFromBackground {
            self.processRemoteNotificationBackgroundMode()
        }else {
            self.processRemoteNotificationLauchApp()
        }
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "お知らせ 12"
        self.showBackButton()
    }
    
    override func setUpComponentsOnLoad() {
        super.setUpComponentsOnLoad()
        
        self.newsTableView.rowHeight = UITableViewAutomaticDimension
        self.newsTableView.estimatedRowHeight = 133;
    }
    
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = NewsDetailViewController.instanceFromStoryBoard("Account") as! NewsDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
