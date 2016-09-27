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
    
    var shop: Shop! {
        didSet {
            self.setDataForCell(shop)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.followButton.setImage(UIImage(named: "shop_button_followed"), forState: .Normal)
    }
    
    @IBAction func followButtonPressed(sender: AnyObject) {
        
    }
    
    func setDataForCell(shop: Shop) {
        
    }

}
