//
//  BaseViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/2/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

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
