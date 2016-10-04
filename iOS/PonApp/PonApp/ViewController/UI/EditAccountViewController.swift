//
//  EditAccountViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import Photos
import AVKit

class EditAccountViewController: BaseViewController {
    
    @IBOutlet weak var genderDropdown: IQDropDownTextField!
    @IBOutlet weak var addressDropdown: IQDropDownTextField!
    @IBOutlet weak var avatarImageView: CircleImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
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
    
    override func setUpComponentsOnLoad() {
        super.setUpComponentsOnLoad()
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "プロフィール編集"
        self.showBackButton()
        self.setupGenderDropdown()
        self.setupAddressDropdown()
    }
    
    override func setUpComponentsOnWillAppear() {
        super.setUpComponentsOnWillAppear()
        self.displayUserInfo()
    }
}

//MARK: - IBAction
extension EditAccountViewController {
    
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        let username = self.nameTextField.text
        let gender = self.genderDropdown.text
        let address = self.addressDropdown.text
        let avatar = self.avatarImageView.image
        self.validInfomation(username, gender: gender, address: address) { (successed: Bool, message: String) in
            if successed {
                self.showHUD()
                ApiRequest.updateUserProfile(username, gender:self.getGender(gender), address: address, avatar: avatar, completion: { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
                    self.hideHUD()
                    if let _ = error {
                        
                    }else {
                        if result?.code == SuccessCode {
                            self.navigationController!.popViewController(animated: true)
                        }
                    }
                })
            }else {
                
            }
        }
    }
    
    @IBAction func editAvatarButtonPressed(_ sender: AnyObject) {
        showImagePickerWithAssetType(.allPhotos) { (assets: [DKAsset]) in
            if assets.count > 0 {
                let asset = assets[0]
                asset.fetchOriginalImageWithCompleteBlock({ (image: UIImage?, info: [AnyHashable: Any]?) in
                    self.avatarImageView.image = image
                })
            }
        }
    }
    
}

//MARK: - Private
extension EditAccountViewController {
    
    fileprivate func setupGenderDropdown() {
        genderDropdown.keyboardDistanceFromTextField = 50
        genderDropdown.delegate = self
        genderDropdown.itemList = [
            "男性",
            "女人"
        ]
    }
    
    fileprivate func setupAddressDropdown() {
        addressDropdown.keyboardDistanceFromTextField = 50
        addressDropdown.delegate = self
        addressDropdown.itemList = [
            "あいちけん",
            "あきたけん",
            "あおもりけん",
            "ちばけん",
            "えひめけん",
            "ふくいけん",
            "ふくおかけん",
            "ふくしまけん",
            "ぎふけん"
        ]
    }
    
    fileprivate func getGender(_ gender: String?) -> Int {
        if let _ = gender {
            if gender! == "男性" {
                return 1
            }
            
            if gender! == "女人" {
                return 2
            }
        }
        return 0
    }
    
    fileprivate func converGender(_ gender: Int?) -> String {
        if let _ = gender {
            if gender! == 1 {
                return "男性"
            }
            
            if gender! == 2 {
                return "女人"
            }
        }
        return ""
    }
    
    func showImagePickerWithAssetType(_ assetType: DKImagePickerControllerAssetType,
                                              allowMultipleType: Bool = false,
                                              sourceType: DKImagePickerControllerSourceType = .both,
                                              singleSelect: Bool = true,
                                              didSelectAssets:@escaping (_ assets: [DKAsset]) -> Void) {
        
        let pickerController = DKImagePickerController()
        
        pickerController.assetType = assetType
        pickerController.allowsLandscape = false
        pickerController.allowMultipleTypes = allowMultipleType
        pickerController.sourceType = sourceType
        pickerController.singleSelect = singleSelect
        
        pickerController.didSelectAssets = didSelectAssets
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        
        self.present(pickerController, animated: true) {}
    }
    
    func validInfomation(_ userName: String?, gender: String?, address: String?, completion:(_ successed: Bool, _ message: String) -> Void) {
        if let _ = userName {
            
        }else {
            completion(false, "Please enter user name")
        }
        
        if let _ = gender {
            
        }else {
            completion(false, "Please enter gender")
        }
        
        if let _ = address {
            
        }else {
            completion(false, "Please enter address")
        }
        completion(true, "")
    }
    
    fileprivate func displayUserInfo() {
        if let _ = UserDataManager.sharedInstance.name {
            self.nameTextField.text = UserDataManager.sharedInstance.name!
        }else {
            self.nameTextField.text = ""
        }
        
        if let _ = UserDataManager.sharedInstance.avatarUrl {
            let avatarUrl = URL(string: UserDataManager.sharedInstance.avatarUrl!)
            self.avatarImageView.af_setImage(withURL: avatarUrl!)
        }else {
            self.avatarImageView.image = UIImage(named: "account_avatar_placehoder")
        }
        
        if let _ = UserDataManager.sharedInstance.email {
            self.emailTextField.text = UserDataManager.sharedInstance.email!
        }else {
            self.emailTextField.text = ""
        }
        
        if let _ = UserDataManager.sharedInstance.gender {
            self.genderDropdown.text = self.converGender(UserDataManager.sharedInstance.gender!)
        }else {
            self.genderDropdown.text = ""
        }
        
        if let _ = UserDataManager.sharedInstance.address {
            self.addressDropdown.text = UserDataManager.sharedInstance.address!
        }else {
            self.addressDropdown.text = ""
        }
    }
    
}

//MARK: - HLKDropDownTextFieldDelegate
extension EditAccountViewController: IQDropDownTextFieldDelegate {
    
    func textField(_ textField: IQDropDownTextField!, didSelectItem item: String!) {
        
    }
    
}
