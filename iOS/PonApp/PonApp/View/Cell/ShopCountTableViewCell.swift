//
//  ShopCountTableViewCell.swift
//  PonApp
//
//  Created by OSXVN on 9/28/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ShopCountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: CircleImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shopCountLabel: UILabel!
    
    var category: Category! {
        didSet {
            self.setDataForCell(self.category)
        }
    }
    
    func setDataForCell(_ category: Category) {
        self.thumbImageView.af_setImage(withURL: URL(string: category.categoryIconUrl)!)
        self.titleLabel.text = category.categoryName
        if let _ = category.shopCount {
            self.shopCountLabel.text = "\(category.shopCount!)"
        }
    }
}
