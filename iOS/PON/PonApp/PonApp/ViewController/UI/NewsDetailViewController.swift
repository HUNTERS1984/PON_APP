//
//  NewsDetailViewController.swift
//  PonApp
//
//  Created by HaoLe on 10/13/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class NewsDetailViewController: BaseViewController {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    open var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationManager.shared.clearNotification()
        if let _ = self.news {
            self.displayNewsDetail(self.news!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.showBackButton()
    }

}

extension NewsDetailViewController {
    
    func displayNewsDetail(_ news: News) {
        self.title = news.title
        self.titleLabel.text = news.title
        self.typeLabel.text = news.type
        self.dateLabel.text = news.createdAt
        self.descriptionTextView.text = news.description
    }
    
}
