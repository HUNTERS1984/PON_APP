//
//  CouponCollectionTableViewCell.swift
//  PonApp
//
//  Created by HaoLe on 9/9/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

typealias MoreButtonPressed = (_ sender: AnyObject, _ categoryId: Float, _ categoryName: String) -> ()

class CouponCollectionTableViewCell: UITableViewCell {
    var categoryId: Float!
    var categoryName: String!
    
    @IBOutlet weak var couponCollectionView: HorizontalCollectionView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var nodataLabel: UILabel!
    
    var moreButtonCallback: MoreButtonPressed? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupTableViewCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTableViewCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupTableViewCell() {
        self.backgroundColor = UIColor.clear
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        couponCollectionView.register(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
        self.nodataLabel.isHidden = true
    }
    
    func setCollectionViewDelegate(delegate: HorizontalCollectionViewDelegate, index: NSInteger, couponListData: CouponListData) {
        if couponListData.coupons.count > 0 {
            self.couponCollectionView.isHidden = false
            self.nodataLabel.isHidden = true
            self.categoryId = couponListData.categoryId
            self.categoryName = couponListData.categoryName
            self.headerLabel.text = couponListData.categoryName
            self.couponCollectionView.handler = delegate
            self.couponCollectionView.coupons = couponListData.coupons
            self.thumbImageView.af_setImage(withURL: URL(string: couponListData.categoryIconUrl)!)
        }else {
            self.couponCollectionView.isHidden = true
            self.nodataLabel.isHidden = false
            self.categoryId = couponListData.categoryId
            self.categoryName = couponListData.categoryName
            self.headerLabel.text = couponListData.categoryName
            self.thumbImageView.af_setImage(withURL: URL(string: couponListData.categoryIconUrl)!)
            self.nodataLabel.text = NoDataMessage
        }
    }
    
    @IBAction func moreButtonPressed(_ sender: AnyObject) {
        if let _ = moreButtonCallback {
            moreButtonCallback!(sender, self.categoryId, self.categoryName)
        }
    }

}
