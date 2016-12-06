//
//  ShopFollowCollectionViewCell.swift
//  PonApp
//
//  Created by HaoLe on 9/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ShopFollowCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avartarImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    
    var completionHandler:((_ shopID: Float?, _ index: Int) -> Void)? = nil
    var index: Int!
    var shop: Shop! {
        didSet {
            self.setDataForCell(self.shop)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func followButtonPressed(_ sender: AnyObject) {
        self.completionHandler?(self.shop.shopID, self.index)
    }
    
    func setDataForCell(_ shop: Shop) {
        if let _ = shop.isFollow {
            if shop.isFollow! {
                self.followButton.setImage(UIImage(named: "shop_button_followed"), for: UIControlState())
            }else {
                self.followButton.setImage(UIImage(named: "shop_button_follow"), for: UIControlState())
            }
        }
    }

}
