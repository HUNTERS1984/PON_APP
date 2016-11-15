//
//  NewsViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class NewsViewController: BaseViewController {

    @IBOutlet weak var newsTableView: UITableView!
    
    var newsArr = [News]()
    //paging
    var canLoadMore: Bool = true
    var currentPage: Int = 1
    var totalPage: Int!
    var nextPage: Int!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if NotificationManager.shared.isAppResumingFromBackground {
            self.processRemoteNotificationBackgroundMode()
        }else {
            self.processRemoteNotificationLauchApp()
        }
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "お知らせ 12"
        self.showBackButton()
    }
    
    override func setUpComponentsOnLoad() {
        super.setUpComponentsOnLoad()
        self.newsTableView.rowHeight = UITableViewAutomaticDimension
        self.newsTableView.estimatedRowHeight = 133;
        self.newsTableView.tableFooterView = UIView()
        self.getNews(self.currentPage)
    }
    
}

extension NewsViewController {
    
    fileprivate func getNews(_ pageIndex: Int) {
        self.showHUD()
        ApiRequest.getNews(pageIndex: pageIndex) {(request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    self.nextPage = result!.nextPage
                    self.totalPage = result!.totalPage
                    self.currentPage = result!.currentPage
                    
                    var responseNews = [News]()
                    let newsArray = result?.data?.array
                    if let _ = newsArray {
                        for newsData in newsArray! {
                            let news = News(response: newsData)
                            responseNews.append(news)
                        }
                        if pageIndex == 1 {
                            self.displayNews(responseNews, type: .new)
                        }else {
                            self.canLoadMore = true
                            self.displayNews(responseNews, type: .loadMore)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func displayNews(_ news: [News], type: GetType) {
        switch type {
        case .new:
            self.newsArr.removeAll()
            self.newsArr = news
            self.newsTableView.reloadData()
            break
        case .loadMore:
            self.newsArr.append(contentsOf: news)
            self.newsTableView.reloadData()
            break
        case .reload:
            break
        }
    }
    
    fileprivate func getNewsDetail(_ newsId: Float) {
        self.showHUD()
        ApiRequest.getNewsDetails(newsId) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    let vc = NewsDetailViewController.instanceFromStoryBoard("Account") as! NewsDetailViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.news = self.newsArr[indexPath.row]
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedNews = self.newsArr[indexPath.row]
        self.getNewsDetail(selectedNews.newsID)
    }
}

extension NewsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.currentPage == self.totalPage {
            return
        }
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && canLoadMore {
            canLoadMore = false
            self.getNews(self.nextPage)
        }
    }
    
}
