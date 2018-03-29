//
//  ZMMovieDetailViewController.swift
//  ZiMu
//
//  Created by fancy on 2018/3/28.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import UIKit
import Alamofire
import QMUIKit
import MJRefresh

/// 详情页
final class ZMMovieDetailViewController: ZMViewController {
    // UI
    fileprivate lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate lazy var infoTextView: QMUITextView = {
        let textView = QMUITextView()
        textView.isEditable = false
        return textView
    }()
    
    
    
    // data
    fileprivate var detailUrl: String!
    
    fileprivate var movie: ZMMovie!
    
    init(url: String, movie: ZMMovie? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.detailUrl = url
        self.movie = movie != nil ? movie : ZMMovie()
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieDetail()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

}

// MARK: - 网络
extension ZMMovieDetailViewController {
    
    fileprivate func getMovieDetail() {
        showLoading()
        Alamofire.request(detailUrl)
            .responseData { [weak self] (response) in
                guard let strongSelf = self else { return }
                strongSelf.hideLoading()
                if response.result.error == nil {
                    if let htmlData = response.result.value {
                        if let doc = TFHpple(htmlData: htmlData) {
                            let movie = ZMMovie()
                            if let homepagePosterNode = doc.search(withXPathQuery: "//img[@class='img-frame aligncenter']").first as? TFHppleElement {
                                movie.homepagePoster = homepagePosterNode["src"] as? String
                                movie.name = homepagePosterNode["alt"] as? String
                            }
                            
                            if let content = doc.search(withXPathQuery: "//div[@class='content-box']").first as? TFHppleElement {
                                
                                let strs = content.content.components(separatedBy: "【资源下载】")
                                if strs.count > 0 {
                                    movie.producerInfo = strs[0]
                                }
                                print(movie.producerInfo)
//                                for node in content.search(withXPathQuery: "//div") {
//                                    let data = node as! TFHppleElement
//                                    print(data.content)
//                                }
                            }
                        }
                    }
                } else {
                    ZMError.handleError(response.result.error)
                }
        }
    }
    
    
}

