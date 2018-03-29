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

    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    fileprivate lazy var gradientView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "image_mask")
        return view
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        getMovieDetail()
    }
    
    override func initSubviews() {
        super.initSubviews()
        view.addSubview(scrollView)
        scrollView.addSubview(postImageView)
        postImageView.addSubview(gradientView)
        scrollView.addSubview(infoTextView)
    }
    
    override func navigationBarTintColor() -> UIColor? {
        return .white
    }
    
    override func navigationBarBackgroundImage() -> UIImage? {
        return ZMUtils.imageWithColor(.clear)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        postImageView.snp.makeConstraints {
            $0.width.equalTo(kScreenWidth)
            $0.top.left.right.equalTo(scrollView)
            $0.height.equalTo(kScreenWidth*1.4149)
        }
        
        gradientView.snp.makeConstraints {
            $0.width.equalTo(kScreenWidth)
            $0.bottom.left.right.equalTo(postImageView)
            $0.height.equalTo(200)
        }
        
        infoTextView.snp.removeConstraints()
        infoTextView.snp.makeConstraints {
            $0.width.equalTo(kScreenWidth)
            $0.bottom.left.right.equalTo(scrollView)
            $0.top.equalTo(postImageView.snp.bottom)
            $0.height.equalTo(infoTextView.contentSize.height)
        }
        
        
    }

    fileprivate func refreshContent() {
        postImageView.setImage(url: movie.homepagePoster)
        infoTextView.attributedText = AppFont.attributeString(kFontRegularName, text: movie.producerInfo, fontSize: 12, fontColor: AppColor.theme.subTitleColor)
        
        viewDidLayoutSubviews()
        
        print(movie.producerInfo)
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
                            if let homepagePosterNode = doc.search(withXPathQuery: "//img[@class='img-frame aligncenter']").first as? TFHppleElement {
                                strongSelf.movie.homepagePoster = homepagePosterNode["src"] as? String
                                strongSelf.movie.name = homepagePosterNode["alt"] as? String
                            }
                            
                            if let homepagePosterNode = doc.search(withXPathQuery: "//img[@class='img-frame  aligncenter']").first as? TFHppleElement {
                                strongSelf.movie.homepagePoster = homepagePosterNode["src"] as? String
                                strongSelf.movie.name = homepagePosterNode["alt"] as? String
                            }
                            
                            if let content = doc.search(withXPathQuery: "//div[@class='content-box']").first as? TFHppleElement {
                                
                                let strs = content.content.components(separatedBy: "【资源下载】")
                                if strs.count > 0 {
                                    strongSelf.movie.producerInfo = strs[0]
                                }
                                
                                for node in content.search(withXPathQuery: "//a") {
                                    let data = node as! TFHppleElement
                                    if data.content == "百度网盘" {
                                        let baiduYun = ZMBaiduYun()
                                        baiduYun.title = ""
                                        baiduYun.url = data["href"] as? String

                                        strongSelf.movie.baiduYuns.append(baiduYun)
                                    }
                                }
                            }
                        }
                    }
                    strongSelf.refreshContent()
                } else {
                    ZMError.handleError(response.result.error)
                }
        }
    }
    
    
}

