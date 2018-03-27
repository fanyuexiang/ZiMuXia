//
//  ZMFoundersViewController.swift
//  ZiMu
//
//  Created by fancy on 2018/3/27.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

/// 创始人
final class ZMFoundersViewController: ZMViewController {
    
    // UI
    fileprivate lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.itemSize = CGSize(width: kScreenWidth, height: kScreenHeight-kStatusBarHeight-kNavigationBarHeight)
        pagerView.automaticSlidingInterval = 3
        pagerView.isInfinite = true
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.register(ZMFounderPagerViewCell.self, forCellWithReuseIdentifier: ZMFounderPagerViewCell.CellIdentifier)
        return pagerView
    }()
    
    fileprivate lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl()
        pageControl.fillColors = [.selected:.gray]
        pageControl.strokeColors = [.normal:.lightGray]
        return pageControl
    }()
    
    
    // data
    fileprivate var founders = [ZMFounder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getFounders()
        title = "FIX创始人"
    }
    
    override func initSubviews() {
        super.initSubviews()
        view.addSubview(pagerView)
        view.addSubview(pageControl)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pagerView.snp.makeConstraints {
            $0.top.equalTo(self.topLayoutGuide.snp.bottom)
            $0.left.right.bottom.equalTo(view)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view).offset(-20.adapted)
        }
    }
    
}

extension ZMFoundersViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return founders.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: ZMFounderPagerViewCell.CellIdentifier, at: index) as! ZMFounderPagerViewCell
        let data = founders[index]
        cell.setupCell(with: data)
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        pageControl.currentPage = index
    }
}

// MARK: - network
extension ZMFoundersViewController {
    
    fileprivate func getFounders() {
        showLoading()
        Alamofire.request("http://www.zimuxia.cn/%E5%88%9B%E5%A7%8B%E4%BA%BA")
            .responseData { [weak self] (response) in
                guard let strongSelf = self else { return }
                strongSelf.hideLoading()
                if response.result.error  == nil {
                    if let htmlData = response.result.value {
                        if let doc = TFHpple(htmlData: htmlData) {
                            for node in doc.search(withXPathQuery: "//div[@class='testimonial-container']") {
                                let founder = ZMFounder()
                                let data = node as! TFHppleElement
                                if let nameNode = (data.search(withXPathQuery: "//h2").first as? TFHppleElement) {
                                    founder.name = nameNode.content
                                }
                                
                                if let positionNode = (data.search(withXPathQuery: "//span").first as? TFHppleElement) {
                                    founder.position = positionNode.content
                                }
                                
                                if let avatarNode = (data.search(withXPathQuery: "//img[@class='img-frame testimonial-img']").first as? TFHppleElement) {
                                    founder.avatar = avatarNode["src"] as? String
                                }
                                
                                if let signNode = (data.search(withXPathQuery: "//blockquote//p").first as? TFHppleElement) {
                                    founder.sign = signNode.content
                                }
                                strongSelf.founders.append(founder)
                            }
                        }
                        strongSelf.pageControl.numberOfPages = strongSelf.founders.count
                        strongSelf.pagerView.reloadData()
                    }
                } else {
                    ZMError.handleError(response.result.error)
                }
        }
    }
}

