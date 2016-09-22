//
//  EditAccountViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class EditAccountViewController: BaseViewController {

    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    
    @IBOutlet weak var genderDropdown: HLKDropDownTextField!
    @IBOutlet weak var perfectureDropdown: HLKDropDownTextField!
    
    
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
    
    override func setUpComponentsOnLoad() {
        super.setUpComponentsOnLoad()
        self.returnKeyHandler = IQKeyboardReturnKeyHandler(viewController: self)
        self.returnKeyHandler?.lastTextFieldReturnKeyType = .Done
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "プロフィール編集"
        self.showBackButton()
        self.setupGenderDropdown()
        self.setupPerfectureDropdown()
    }
}

//MARK: - Private
extension EditAccountViewController {
    
    private func setupGenderDropdown() {
        self.genderDropdown.placeHolderText = "男性"
        self.genderDropdown.handler = self
        let types = [
            HLKDropDownItem(itemId: 1, itemTitle: "Male"),
            HLKDropDownItem(itemId: 2, itemTitle: "Female"),
            HLKDropDownItem(itemId: 3, itemTitle: "LGBT"),
            ]
        
        genderDropdown.itemList = types
    }
    
    private func setupPerfectureDropdown() {
        self.perfectureDropdown.placeHolderText = "東京都"
        self.perfectureDropdown.handler = self
        let types = [
            HLKDropDownItem(itemId: 1, itemTitle: "Male"),
            HLKDropDownItem(itemId: 2, itemTitle: "Female"),
            HLKDropDownItem(itemId: 3, itemTitle: "LGBT"),
            ]
        
        perfectureDropdown.itemList = types
    }
    
}

//MARK: - HLKDropDownTextFieldDelegate
extension EditAccountViewController: HLKDropDownTextFieldDelegate {
    
    func dropDownTextField(dropdown: HLKDropDownTextField, didSelectItem item: HLKDropDownItem, atIndex index: Int) {
        
    }
    
    func dropDownTextFieldShouldBeginEditing(dropdown: HLKDropDownTextField) {
        
    }
    
}
