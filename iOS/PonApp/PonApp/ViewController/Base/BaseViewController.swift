//
//  BaseViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/2/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {
    
    deinit {
        loggingPrint("\(self.classForCoder) deinit")
    }
    
    //MARK: - Public
    weak var appDelegate:AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        self.view.backgroundColor = UIColor.whiteColor()
        
        setUpComponentsOnLoad()
        setUpUserInterface()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle{
        return UIStatusBarStyle.Default;
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configUserInterface()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setUpComponentsOnWillAppear()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setUpComponentsOnDidAppear()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        setUpComponentsOnDidDisappear()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        setUpComponentsOnWillDisappear()
    }
    
}

//MARK: - Public Methods
extension BaseViewController {
    
    func hideBackButton() {
        let button = UIBarButtonItem(image: UIImage(), style: .Plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = button
    }
    
    func showBackButton() {
        let button = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .Plain, target: self, action: #selector(self.backButtonPressed(_: )))
        self.navigationItem.leftBarButtonItem = button
    }
    
    func showAddButton() {
        let button = UIBarButtonItem(image: UIImage(named: "nav_add"), style: .Plain, target: self, action: #selector(self.navAddButtonPressed(_: )))
        self.navigationItem.leftBarButtonItem = button
    }
    
    func showRightBarButtonWithTitle(title: String) {
        let button = UIBarButtonItem(title: title, style: .Plain, target: self, action: #selector(self.rightBarButtonPressed(_: )))
        button.setTitleTextAttributes([NSFontAttributeName: UIFont.HiraginoSansW6(17)], forState: UIControlState.Normal)
        self.navigationItem.rightBarButtonItem = button
    }
    
    func showCloseButton() {
        let button = UIBarButtonItem(image: UIImage(named: "nav_close_white"), style: .Plain, target: self, action: #selector(self.navCloseButtonPressed(_: )))
        self.navigationItem.leftBarButtonItem = button
    }
}

//MARK: - IBAction 
extension BaseViewController {
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func navAddButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func rightBarButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func navCloseButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
}
