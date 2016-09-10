//
//  HomeSearchViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class HomeSearchViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "nav_search"), style: .Plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.showSearchBox()
        self.showRightBarButtonWithTitle("キャンセル")
    }

}

//MARK: - IBAction
extension HomeSearchViewController {
    
    @IBAction func locationButtonPressed(sender: AnyObject) {
        let vc = HomeMapViewController.instanceFromStoryBoard("MainMenu")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func rightBarButtonPressed(sender: AnyObject) {
        super.rightBarButtonPressed(sender)
        self.navigationController?.popViewControllerAnimated(false)
    }
    
}

//MARK: - Private
extension HomeSearchViewController {
    
    private func showSearchBox() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        
        let searchBox = UITextField(frame: CGRectMake(0, 0, screenWidth - 60, 30))
        searchBox.backgroundColor = UIColor.clearColor()
        searchBox.textColor = UIColor.whiteColor()
        searchBox.font = UIFont.HiraginoSansW6(17)
        searchBox.placeholder = "地名/ショップ名を入力"
        searchBox.borderStyle = .None
        searchBox.autoresizingMask = .FlexibleWidth
        self.navigationItem.titleView = searchBox
    }
    
}

extension HomeSearchViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell?
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
}

extension HomeSearchViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
