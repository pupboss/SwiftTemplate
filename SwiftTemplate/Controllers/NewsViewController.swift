//
//  NewsViewController.swift
//  SwiftTemplate
//
//  Created by Jie Li on 23/7/20.
//  Copyright © 2020 Meltdown Research. All rights reserved.
//

import UIKit
import MJRefresh
import SafariServices

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate {
    
    let cellReuseIdentifier = "NewsTableViewCellIdentifier"
    
    var newsListPage = 1
    let newsListPageSize = 15
    
    var news: [NewsModel] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.tc.subBackground
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.tc.background
        navigationItem.title = "News"

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.fetchDataFromServer()
        })
        tableView.mj_header?.isAutomaticallyChangeAlpha = true
        
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.appendDataFromServer()
        })
        
        tableView.mj_header?.beginRefreshing()
        
        registerForPreviewing(with: self, sourceView: tableView)
    }
    
    func fetchDataFromServer() {
        
        newsListPage = 1
        let path = "/api/v1/news.json"
        
        APIService.shared.requestDecodable(method: .get, path: path, params: ["pageSize": newsListPageSize, "page": newsListPage], paramsType: .form, decodableType: [NewsModel].self) { (result) in
            switch result {
            case .success(let value):
                self.news.removeAll()
                self.news.append(contentsOf: value)

                if self.news.count > 0 {
                    self.tableView.mj_footer?.resetNoMoreData()
                } else {
                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }

                self.tableView.reloadData()
                self.tableView.mj_header?.endRefreshing()
                self.newsListPage = 2
            case .failure(let error):
                self.view.makeToast(error.message)
            }
        }
    }
    
    func appendDataFromServer() {
        
        APIService.shared.requestDecodable(method: .get, path: "/api/v1/news.json", params: ["pageSize": newsListPageSize, "page": newsListPage], paramsType: .form, decodableType: [NewsModel].self) { (result) in
            switch result {
            case .success(let value):

                if value.count > 0 {
                    self.news.append(contentsOf: value)
                    self.tableView.reloadData()
                    self.newsListPage += 1

                    self.tableView.mj_footer?.endRefreshing()
                } else {
                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
            case .failure(let error):
                self.view.makeToast(error.message)
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! NewsTableViewCell
        cell.new = news[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let url = URL(string: news[indexPath.row].url) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let indexPath = tableView.indexPathForRow(at: location)!
        let cell = tableView.cellForRow(at: indexPath) as! NewsTableViewCell
        previewingContext.sourceRect = cell.frame
        
        if let url = URL(string: news[indexPath.row].url) {
            let vc = SFSafariViewController(url: url)
            vc.preferredContentSize = .zero
            return vc
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        present(viewControllerToCommit, animated: true)
    }
}
