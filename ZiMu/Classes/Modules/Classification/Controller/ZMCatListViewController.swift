//
//  ZMCatListViewController.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/27.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation
import QMUIKit
import Alamofire
import MJRefresh

/// 分类详情列表
final class ZMCatListViewController: ZMViewController {
    
    // UI
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = ZJFlexibleLayout(delegate: self)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ZMMovieCollectionViewCell.self, forCellWithReuseIdentifier: ZMMovieCollectionViewCell.CellIdentifier)
        collectionView.register(ZMCollectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ZMCollectionHeader.CellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    var refreshAutoNormalFooter: MJRefreshAutoNormalFooter!
    
    // data
    private var cat: String!
    fileprivate lazy var movies = [ZMMovie]()
    fileprivate var currentPage: Int = 1
    
    init(cat: String) {
        super.init(nibName: nil, bundle: nil)
        self.cat = cat
        title = cat
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configRefreshFooter()
        
        // network
        showLoading()
        getAllMovies()
    }
    
    override func initSubviews() {
        super.initSubviews()
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
    }
    
    private func configRefreshFooter() {
        refreshAutoNormalFooter = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(ZMCatListViewController.getAllMovies))
        refreshAutoNormalFooter.setTitle("", for: .idle)
        collectionView.mj_footer = refreshAutoNormalFooter
    }
    
}

// MARK: - ZJFlexibleDataSource
extension ZMCatListViewController: ZJFlexibleDataSource {
    func numberOfCols(at section: Int) -> Int {
        return 2
    }
    
    func sizeOfItemAtIndexPath(at indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140.adapted, height: 260.adapted)
    }
    
    func spaceOfCells(at section: Int) -> CGFloat {
        return 20.adapted
    }
    
    func heightOfAdditionalContent(at indexPath: IndexPath) -> CGFloat {
        return 10.adapted
    }
    
    func sizeOfHeader(at section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func sectionInsets(at section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.adapted, left: 15.adapted, bottom: 10.adapted, right: 15.adapted)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ZMCatListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZMMovieCollectionViewCell.CellIdentifier, for: indexPath) as! ZMMovieCollectionViewCell
        let data = movies[indexPath.item]
        cell.setupCell(with: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = movies[indexPath.item]
        if let url = data.homepageUrl {
            let detailVC = ZMMovieDetailViewController(url: url, movie: data)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ZMMovieCollectionViewCell
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ZMMovieCollectionViewCell
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }

}

// MARK: - network
extension ZMCatListViewController {
    @objc fileprivate func getAllMovies() {
        Alamofire.request("http://www.zimuxia.cn/%E6%88%91%E4%BB%AC%E7%9A%84%E4%BD%9C%E5%93%81", method: .get, parameters: ["cat": "\(cat!)","set":"\(currentPage)" ], encoding: URLEncoding.default)
            .responseData { [weak self] (response) in
                guard let strongSelf = self else { return }
                strongSelf.hideLoading()
                if response.result.error  == nil {
                    if let htmlData = response.result.value {
                        if let doc = TFHpple(htmlData: htmlData) {
                            if doc.search(withXPathQuery: "//div[@class='pg-item']").count != 0 {
                                strongSelf.currentPage += 1
                                strongSelf.refreshAutoNormalFooter.endRefreshing()
                            } else {
                                strongSelf.refreshAutoNormalFooter.endRefreshingWithNoMoreData()
                            }
                            for node in doc.search(withXPathQuery: "//div[@class='pg-item']") {
                                let movie = ZMMovie()
                                let data = node as! TFHppleElement
                                if let nameNode = (data.search(withXPathQuery: "//a").first as? TFHppleElement) {
                                    movie.name = nameNode["title"] as? String
                                }
                                
                                if let urlNode = (data.search(withXPathQuery: "//a").first as? TFHppleElement) {
                                    movie.homepageUrl = urlNode["href"] as? String
                                }
                                
                                if let bgNode = (data.search(withXPathQuery: "//img").first as? TFHppleElement) {
                                    movie.poster = bgNode["src"] as? String
                                }
                                
                                movie.classification = (data.search(withXPathQuery: "//span[@class='pg-categories']").first as? TFHppleElement)?.content
                                strongSelf.movies.append(movie)
                            }
                        }
                        strongSelf.collectionView.reloadData()
                    } else {
                        ZMError.handleError(response.result.error)
                    }
                } else {
                    strongSelf.refreshAutoNormalFooter.endRefreshingWithNoMoreData()
                    ZMError.handleError(response.result.error)
                }
        }
    }
}
