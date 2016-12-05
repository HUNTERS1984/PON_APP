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
        self.nameTextField.attributedPlaceholder = NSAttributedString(string:"ユーザー名", attributes:[NSForegroundColorAttributeName: UIColor(hex: DefaultDarkTextColor)])
        self.emailTextField.attributedPlaceholder = NSAttributedString(string:"example@ex.com", attributes:[NSForegroundColorAttributeName: UIColor(hex: DefaultDarkTextColor)])
        self.genderDropdown.attributedPlaceholder = NSAttributedString(string:"男性", attributes:[NSForegroundColorAttributeName: UIColor(hex: DefaultDarkTextColor)])
        self.addressDropdown.attributedPlaceholder = NSAttributedString(string:"東京都", attributes:[NSForegroundColorAttributeName: UIColor(hex: DefaultDarkTextColor)])
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "プロフィール編集"
        self.showBackButton()
        self.setupGenderDropdown()
        self.setupAddressDropdown()
        self.displayUserInfo()
    }
    
    override func setUpComponentsOnWillAppear() {
        super.setUpComponentsOnWillAppear()
    }
}

//MARK: - IBAction
extension EditAccountViewController {
    
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        let username = self.nameTextField.text
        let gender = self.genderDropdown.text
        let address = self.addressDropdown.text
        let avatar = self.avatarImageView.image
        self.validInfomation(username, gender: gender, address: address) { [weak self] (successed: Bool, message: String) in
            if successed {
                self?.showHUD()
                ApiRequest.updateUserProfile(username, gender:self?.getGender(gender), address: address, avatar: avatar, completion: { [weak self] (request: URLRequest?, result: ApiResponse?, error: NSError?) in
                    self?.hideHUD()
                    if let _ = error {
                        
                    }else {
                        if result?.code == SuccessCode {
                            UserDataManager.setUserData(result?.data)
                            UserDataManager.shared.avatarImage = avatar
                            _ = self?.navigationController?.popViewController(animated: true)
                        }else {
                            self?.presentAlert(message: (result?.message)!)
                        }
                    }
                })
            }else {
                self?.presentAlert(message: message)
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
            "男",
            "女",
            "LGBT"
        ]
    }
    
    fileprivate func setupAddressDropdown() {
        addressDropdown.keyboardDistanceFromTextField = 50
        addressDropdown.delegate = self
        addressDropdown.itemList = [
            "愛知県",
            "秋田県",
            "青森県",
            "千葉県",
            "愛媛県",
            "福井県",
            "福岡県",
            "福島県",
            "岐阜県",
            "群馬県",
            "広島県",
            "北海道",
            "兵庫県",
            "茨城県",
            "石川県",
            "岩手県",
            "香川県",
            "鹿児島県",
            "神奈川県",
            "高知県",
            "熊本県",
            "京都府",
            "三重県",
            "宮城県",
            "宮崎県",
            "長野県",
            "長崎県",
            "奈良県",
            "新潟県",
            "大分県",
            "岡山県",
            "沖縄県",
            "大阪府",
            "佐賀県",
            "埼玉県",
            "滋賀県",
            "島根県",
            "静岡県",
            "栃木県",
            "徳島県",
            "東京都",
            "鳥取県",
            "富山県",
            "和歌山県",
            "山形県",
            "山口県",
            "山梨県"
        ]
    }
    
    fileprivate func getGender(_ gender: String?) -> Int {
        if let _ = gender {
            if gender! == "男" {
                return 0
            }
            
            if gender! == "女" {
                return 1
            }
            if gender! == "LGBT" {
                return 2
            }
        }
        return 0
    }
    
    fileprivate func converGender(_ gender: Int?) -> String {
        if let _ = gender {
            if gender! == 0 {
                return "男"
            }
            
            if gender! == 1 {
                return "女"
            }
            
            if gender! == 2 {
                return "LGBT"
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
            if userName!.characters.count == 0 {
                completion(false, UserNameBlank)
                return
            }
        }else {
            completion(false, UserNameBlank)
        }
        
        if let _ = gender {
            if gender!.characters.count == 0 {
                completion(false, GenderBlank)
                return
            }
        }else {
            completion(false, GenderBlank)
        }
        
        if let _ = address {
            if address!.characters.count == 0 {
                completion(false, AddressBlank)
                return
            }
        }else {
            completion(false, AddressBlank)
        }
        completion(true, "")
    }
    
    fileprivate func displayUserInfo() {
        if let _ = UserDataManager.shared.username {
            self.nameTextField.text = UserDataManager.shared.username!
        }else {
            self.nameTextField.text = ""
        }
        
        if let _ = UserDataManager.shared.avatarUrl {
            let avatarUrl = URL(string: UserDataManager.shared.avatarUrl!)
            self.avatarImageView.af_setImage(withURL: avatarUrl!)
        }else {
            self.avatarImageView.image = UIImage(named: "edit_profile_avatar_placeholder")
        }
        
        if let _ = UserDataManager.shared.email {
            self.emailTextField.text = UserDataManager.shared.email!
        }else {
            self.emailTextField.text = ""
        }
        
        if let _ = UserDataManager.shared.gender {
            self.genderDropdown.text = self.converGender(UserDataManager.shared.gender!)
        }else {
            self.genderDropdown.text = ""
        }
        
        if let _ = UserDataManager.shared.address {
            self.addressDropdown.text = UserDataManager.shared.address!
        }else {
            self.addressDropdown.text = ""
        }
    }
    
}

//MARK: - IQDropDownTextFieldDelegate
extension EditAccountViewController: IQDropDownTextFieldDelegate {
    
    func textField(_ textField: IQDropDownTextField!, didSelectItem item: String!) {
        
    }
    
}
