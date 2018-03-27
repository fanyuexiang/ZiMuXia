//
//  ZMMainViewController.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/25.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation
import Alamofire
import QMUIKit
import MJRefresh

final class ZMMainViewController: ZMViewController {
    
    // UI
    private lazy var leftItemLabel: UILabel = {
        let label = UILabel(textColor: AppColor.theme.titleColor, fontSize: 26.adapted, FontName: kFontMediumName)
        label.frame = CGRect(x: 0, y: 0, width: 60.adapted, height: 44)
        label.text = "推荐"
        return label
    }()
    
    fileprivate lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 190.adapted))
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.itemSize = CGSize(width: kScreenWidth, height: 170.adapted)
        pagerView.automaticSlidingInterval = 3
        pagerView.isInfinite = true
        pagerView.transformer = FSPagerViewTransformer(type: .zoomOut)
        pagerView.register(ZMMainPagerViewCell.self, forCellWithReuseIdentifier: ZMMainPagerViewCell.CellIdentifier)
        return pagerView
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = ZJFlexibleLayout(delegate: self)
        layout.collectionHeaderView = pagerView
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
    fileprivate lazy var banners = [ZMBanner]()
    fileprivate lazy var movies = [ZMMovie]()
    fileprivate lazy var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigation()
        configRefreshFooter()
        // network
        getBanner()
        getAllMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
    }
    
    fileprivate func configNavigation() {
        ZMUtils.hideSeparator(navigationController)
        let leftBarButtonItem = UIBarButtonItem(customView: leftItemLabel)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        let rightItem = QMUINavigationButton.barButtonItem(with: UIImage(named: "icon_search"), position: .right, target: self, action: #selector(ZMMainViewController.search))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func configRefreshFooter() {
        refreshAutoNormalFooter = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(ZMMainViewController.getAllMovies))
        refreshAutoNormalFooter.setTitle("", for: .idle)
        collectionView.mj_footer = refreshAutoNormalFooter
    }
    
    override func initSubviews() {
        view.addSubview(pagerView)
        view.addSubview(collectionView)
    }
    
    override func setNavigationItemsIsInEditMode(_ isInEditMode: Bool, animated: Bool) { }
    
    @objc private func search() {
        dPrint(message: "搜索")
    }
}

// MARK: - ZJFlexibleDataSource
extension ZMMainViewController: ZJFlexibleDataSource {
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
        return CGSize(width: kScreenWidth, height: 50.adapted)
    }
    
    func sectionInsets(at section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.adapted, left: 15.adapted, bottom: 10.adapted, right: 15.adapted)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ZMMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {

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
        print(data.name)
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ZMCollectionHeader.CellIdentifier, for: indexPath) as! ZMCollectionHeader
        if movies.count != 0 {
            header.setupHeader(with: "全部作品")
        }
        return header
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        var scale: CGFloat = 1
        let top = kNavigationBarHeight + kStatusBarHeight
        if offsetY <= -top {
            scale = 1
        } else if offsetY > -top && offsetY < -top+50 {
            scale = 1 - (offsetY + top) / 50 * 0.34
        } else {
            scale = 0.66
        }
        leftItemLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
}

// MARK: - FSPagerViewDataSource, FSPagerViewDelegate
extension ZMMainViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return banners.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: ZMMainPagerViewCell.CellIdentifier, at: index) as! ZMMainPagerViewCell
        let data = banners[index]
        cell.setupCell(with: data)
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let data = banners[index]
        print(data.url)
    }
}

// MARK: - 网络
extension ZMMainViewController {
    fileprivate func getBanner() {
        showLoading()
        Alamofire.request("http://www.zimuxia.cn/")
            .responseData { [weak self] (response) in
            guard let strongSelf = self else { return }
            strongSelf.hideLoading()
            if response.result.error  == nil {
                if let htmlData = response.result.value {
                    if let doc = TFHpple(htmlData: htmlData) {
                        
                        for node in doc.search(withXPathQuery: "//div[@class='section section-text layout-rb']") {
                            let banner = ZMBanner()
                            let data = node as! TFHppleElement
                            banner.backgroundImage = strongSelf.backgroundImageUrl(data["style"] as? String)
                            banner.title = (data.search(withXPathQuery: "//h2").first as? TFHppleElement)?.content
                            banner.desc = (data.search(withXPathQuery: "//a").first as? TFHppleElement)?.content
                            if let urlNode = (data.search(withXPathQuery: "//a").first as? TFHppleElement) {
                                banner.url = urlNode["href"] as? String
                            }
                            strongSelf.banners.append(banner)
                        }
                        for node in doc.search(withXPathQuery: "//div[@class='section section-text layout-cb']") {
                            let banner = ZMBanner()
                            let data = node as! TFHppleElement
                            banner.backgroundImage = strongSelf.backgroundImageUrl(data["style"] as? String)
                            banner.title = (data.search(withXPathQuery: "//h2").first as? TFHppleElement)?.content
                            banner.desc = (data.search(withXPathQuery: "//a").first as? TFHppleElement)?.content
                            if let urlNode = (data.search(withXPathQuery: "//a").first as? TFHppleElement) {
                                banner.url = urlNode["href"] as? String
                            }
                            strongSelf.banners.append(banner)
                        }
                    }
                }
                strongSelf.pagerView.reloadData()
            } else {
                ZMError.handleError(response.result.error)
            }
        }
    }
    
    fileprivate func backgroundImageUrl(_ url: String?) -> String {
        if let backgroundImage = url {
            if let start = backgroundImage.index(of: "h"), let end = backgroundImage.index(of: ")") {
                let range = start..<end
                let mystr = backgroundImage[range]
                return String(mystr)
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
    @objc fileprivate func getAllMovies() {
        Alamofire.request("http://www.zimuxia.cn/%E6%88%91%E4%BB%AC%E7%9A%84%E4%BD%9C%E5%93%81?set=\(currentPage)")
            .responseData { [weak self] (response) in
                guard let strongSelf = self else { return }
                strongSelf.refreshAutoNormalFooter.endRefreshing()
                if response.result.error  == nil {
                    strongSelf.currentPage += 1
                    if let htmlData = response.result.value {
                        if let doc = TFHpple(htmlData: htmlData) {
                            for node in doc.search(withXPathQuery: "//div[@class='pg-item']") {
                                let movie = ZMMovie()
                                let data = node as! TFHppleElement
                                if let nameNode = (data.search(withXPathQuery: "//a").first as? TFHppleElement) {
                                    movie.name = nameNode["title"] as? String
                                }
                                
                                if let urlNode = (data.search(withXPathQuery: "//a").first as? TFHppleElement) {
                                    movie.url = urlNode["href"] as? String
                                }
                                
                                if let bgNode = (data.search(withXPathQuery: "//img").first as? TFHppleElement) {
                                    movie.backgroundImage = bgNode["src"] as? String
                                }
                                
                                movie.info = (data.search(withXPathQuery: "//span[@class='pg-categories']").first as? TFHppleElement)?.content
                                strongSelf.movies.append(movie)
                            }
                        }
                    strongSelf.collectionView.reloadData()
                } else {
                    ZMError.handleError(response.result.error)
                }
            }
        }
    }

}
