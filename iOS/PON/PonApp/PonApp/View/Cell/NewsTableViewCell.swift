//
//  NewsTableViewCell.swift
//  PonApp
//
//  Created by HaoLe on 10/6/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import AlamofireImage

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: CircleImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: ReadMoreTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var news: News! {
        didSet {
            self.setDataForCell(self.news)
        }
    }
    
    func setDataForCell(_ news: News) {
        iconImageView.af_setImage(withURL: URL(string: news.imageUrl)!)
        titleLabel.text = news.title
        descriptionLabel.text = news.introduction
    }

}
