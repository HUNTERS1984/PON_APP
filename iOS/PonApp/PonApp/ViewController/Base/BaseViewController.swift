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
        let backButton = UIBarButtonItem(image: UIImage(), style: .Plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func showBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .Plain, target: self, action: #selector(self.backButtonPressed(_: )))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
}

//MARK: - IBAction 
extension BaseViewController {
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
