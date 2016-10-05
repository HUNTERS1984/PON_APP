//
//  CouponCollectionViewCell.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CouponCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var confirmView: DesignableView!
    @IBOutlet weak var couponContentView: DesignableView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var likeIconImage: UIImageView!
    @IBOutlet weak var usedIconImage: UIImageView!
    
    var completionHandler:(()->Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCollectionViewCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupCollectionViewCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCollectionViewCell()
    }
    
    func setupCollectionViewCell() {
        self.backgroundColor = UIColor.clear
    }
    
    var coupon: Coupon! {
        didSet {
            self.setDataForCell(self.coupon)
        }
    }
    
    func setDataForCell(_ coupon: Coupon) {
        if coupon.showConfirmView {
            self.confirmView.isHidden = false
            self.couponContentView.isHidden = true
        }else {
            self.confirmView.isHidden = true
            self.couponContentView.isHidden = false
        }
        
        self.usedIconImage.isHidden = !coupon.isUsed
        let URL = Foundation.URL(string: coupon.imageURL)!
        self.thumbImageView.af_setImage(withURL: URL)
        self.titleLabel.text = coupon.title
        self.expireDateLabel.text = coupon.expiryDate
        if let _ = coupon.isLike {
            if coupon.isLike! {
                self.likeIconImage.isHidden = false
                self.likeIconImage.image = UIImage(named: "coupon_liked")
            }else {
                self.likeIconImage.isHidden = false
                self.likeIconImage.image = UIImage(named: "coupon_normal")
            }
        }else {
            self.likeIconImage.isHidden = true
        }
        self.typeLabel.text = coupon.couponType
    }
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        self.completionHandler?()
    }
}
