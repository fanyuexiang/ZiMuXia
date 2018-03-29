//
//  ZMSearchViewController.swift
//  ZiMu
//
//  Created by fancy on 2018/3/28.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import UIKit
import Alamofire
import QMUIKit
import MJRefresh

/// 搜索
final class ZMSearchViewController: ZMTableViewController {
    
    // UI
    internal lazy var zmSearchBar: QMUISearchBar = {
        let searchBar = QMUISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    var refreshAutoNormalFooter: MJRefreshAutoNormalFooter!
    
    // data
    fileprivate var currentPage = 1
    fileprivate var results = [ZMMovie]()
    fileprivate var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configRefreshFooter()
    }
    
    override func setupCommonBackItem() {
        ZMUtils.hideSeparator(navigationController)
        let closeItem = QMUINavigationButton.barButtonItem(with: .normal, title: "取消", position: .right, target: self, action: #selector(ZMSearchViewController.close))
        navigationItem.rightBarButtonItem = closeItem
    }
    
    override func initTableView() {
        super.initTableView()
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.register(ZMSearchResultCell.self, forCellReuseIdentifier: ZMSearchResultCell.CellIdentifier)
    }
    
    override func setNavigationItemsIsInEditMode(_ isInEditMode: Bool, animated: Bool) {
        navigationItem.titleView = zmSearchBar
    }
    
    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func configRefreshFooter() {
        refreshAutoNormalFooter = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(ZMSearchViewController.search))
        refreshAutoNormalFooter.setTitle("", for: .idle)
        tableView.mj_footer = refreshAutoNormalFooter
    }
    
}

// MARK: - UISearchBarDelegate
extension ZMSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            currentPage = 1
            self.searchText = searchText
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        currentPage = 1
        results.removeAll()
        search()
        showLoading()
    }
    
}

// MARK: - 代理
extension ZMSearchViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.adapted
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZMSearchResultCell.CellIdentifier, for: indexPath) as! ZMSearchResultCell
        let data = results[indexPath.row]
        cell.setupCell(with: data)
        return cell 
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = results[indexPath.row]
        if let url = data.homepageUrl {
            let detailVC = ZMMovieDetailViewController(url: url, movie: data)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}

// MARK: - 网络
extension ZMSearchViewController {
    @objc fileprivate func search() {
        Alamofire.request("http://www.zimuxia.cn/page/\(currentPage)", method: .get, parameters: ["s": searchText], encoding: URLEncoding.default, headers: nil)
            .responseData { [weak self] (response) in
                guard let strongSelf = self else { return }
                strongSelf.hideLoading()
                if response.result.error == nil {
                    if let htmlData = response.result.value {
                        if let doc = TFHpple(htmlData: htmlData) {
                            if doc.search(withXPathQuery: "//article").count != 0 {
                                strongSelf.currentPage += 1
                                strongSelf.refreshAutoNormalFooter.endRefreshing()
                            } else {
                                strongSelf.refreshAutoNormalFooter.endRefreshingWithNoMoreData()
                            }
                            for node in doc.search(withXPathQuery: "//article") {
                                let result = ZMMovie()
                                let data = node as! TFHppleElement
                                if let nameNode = data.search(withXPathQuery: "//h2//a").first as? TFHppleElement {
                                    result.name = nameNode.content
                                    result.homepageUrl = nameNode["href"] as? String
                                }
                                
                                if let contentNode = data.search(withXPathQuery: "//div[@class='post-content-content']//p").first as? TFHppleElement {
                                    result.producerInfo = contentNode.content
                                }
                                strongSelf.results.append(result)
                            }
                        }
                    }
                    strongSelf.tableView.reloadData()
                } else {
                    strongSelf.hideLoading()
                    ZMError.handleError(response.result.error)
                }
        }
    }
}
