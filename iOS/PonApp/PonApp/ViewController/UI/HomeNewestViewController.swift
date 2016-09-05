//
//  HomeNewestViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class HomeNewestViewController: UITableViewController {

    var parentNavigationController : UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

extension HomeNewestViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell?
        cell!.textLabel?.text = "Newest"
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
    }
    
}

extension HomeNewestViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
