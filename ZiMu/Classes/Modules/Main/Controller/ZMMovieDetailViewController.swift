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
import SnapKit
import SafariServices

/// 详情页
final class ZMMovieDetailViewController: ZMViewController, UIScrollViewDelegate {
    
    // constant
    private let postImageViewHeight: CGFloat = kScreenWidth*1.4149
    private var postImageViewHeightConstraint: Constraint?
    fileprivate var navigationBarColor: UIColor = .clear
    fileprivate var navigationTintColor: UIColor = .white
    
    // UI
    fileprivate lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate lazy var postMaskImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image_mask")
        return imageView
    }()
    
    fileprivate lazy var nameLabel: QMUILabel = {
        let label = QMUILabel(textColor: .white, fontSize: 24.adapted, FontName: kFontSemiboldName)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var infoLabel: QMUILabel = {
        let label = QMUILabel(textColor: AppColor.theme.subTitleColor, fontSize: 12.adapted, FontName: kFontLightName)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var favoriteBtn: QMUIButton = {
        let btn = QMUIButton()
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setImage(UIImage(named: "icon_favorites_def"), for: .normal)
        btn.setImage(UIImage(named: "icon_favorites_sel"), for: .selected)
        btn.addTarget(self, action: #selector(ZMMovieDetailViewController.handleFavorite(_:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var baiduYunLabel: QMUILabel = {
        let label = QMUILabel(textColor: AppColor.theme.subTitleColor, fontSize: 20.adapted, FontName: kFontSemiboldName)
        label.text = "传送门"
        return label
    }()
    
    fileprivate lazy var floatLayoutView: QMUIFloatLayoutView = {
        let floatLayoutView = QMUIFloatLayoutView()
        floatLayoutView.padding = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        floatLayoutView.itemMargins = UIEdgeInsetsMake(6, 6, 6, 6)
        floatLayoutView.minimumItemSize = CGSize(width: 65, height: 30)// 以2个字的按钮作为最小宽度
        return floatLayoutView
    }()

    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        return scrollView
    }()
    
    // data
    fileprivate var detailUrl: String!
    
    fileprivate var movie: ZMMovie!
    
    init(url: String, movie: ZMMovie? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.detailUrl = url
        self.movie = movie != nil ? movie?.copy() : ZMMovie()
        postImageView.hero.id = movie?.name
        postImageView.setImage(url: movie?.poster ?? movie?.homepagePoster)
        nameLabel.text = movie?.name
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.zm_reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hero.isEnabled = true
        navigationController?.navigationBar
            .zm_setBackgroundColor(backgroundColor: navigationBarColor)
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
        scrollView.addSubview(postMaskImageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(favoriteBtn)
        scrollView.addSubview(infoLabel)
        scrollView.addSubview(baiduYunLabel)
        scrollView.addSubview(floatLayoutView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        postImageView.snp.makeConstraints {
            $0.width.equalTo(kScreenWidth)
            $0.top.left.right.equalTo(scrollView)
            postImageViewHeightConstraint = $0.height.equalTo(postImageViewHeight).constraint
        }
        
        postMaskImageView.snp.makeConstraints {
            $0.edges.equalTo(postImageView)
        }
        
        nameLabel.snp.makeConstraints {
            $0.bottom.equalTo(postMaskImageView).offset(-30)
            $0.left.equalTo(postMaskImageView).offset(30)
            $0.width.lessThanOrEqualToSuperview()
        }
        
        favoriteBtn.snp.makeConstraints {
            $0.bottom.equalTo(postMaskImageView).offset(-15)
            $0.right.equalTo(postMaskImageView).offset(-30)
            $0.width.height.equalTo(50)
        }
        
        infoLabel.snp.makeConstraints {
            $0.right.equalTo(scrollView).offset(-10)
            $0.left.equalTo(scrollView).offset(10)
            $0.width.equalTo(kScreenWidth-20)
            $0.top.equalTo(postImageView.snp.bottom)
        }
        
        baiduYunLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(6)
            $0.left.equalTo(scrollView).offset(10)
            $0.width.lessThanOrEqualToSuperview()
        }
        
        let floatLayoutViewSize = floatLayoutView.sizeThatFits(CGSize(width: kScreenWidth, height: CGFloat.greatestFiniteMagnitude))
        floatLayoutView.snp.removeConstraints()
        floatLayoutView.snp.makeConstraints {
            $0.width.equalTo(kScreenWidth)
            $0.top.equalTo(baiduYunLabel.snp.bottom).offset(6)
            $0.left.right.equalTo(scrollView)
            $0.bottom.equalTo(scrollView).offset(-20)
            $0.height.equalTo(floatLayoutViewSize.height)
        }
    }

    // MARK: - 导航栏
    override func navigationBarTintColor() -> UIColor? {
        return navigationTintColor
    }
    
    override func navigationBarBackgroundImage() -> UIImage? {
        return ZMUtils.imageWithColor(.clear)
    }
    
    fileprivate func changeNavigationBarColor(contentOffset: CGPoint) {
        if contentOffset.y < 0 {
            navigationBarColor = .clear
        } else if contentOffset.y < postImageViewHeight {
            navigationBarColor = UIColor.white.withAlphaComponent(contentOffset.y / postImageViewHeight)
        } else {
            navigationBarColor = .white
        }
        navigationTintColor = UIColor(white: 1-contentOffset.y / postImageViewHeight, alpha: 1)
        navigationController?.navigationBar.tintColor = navigationTintColor
        navigationController?.navigationBar.zm_setBackgroundColor(backgroundColor: navigationBarColor)
    }
    
    // MARK: - action
    @objc fileprivate func handleFavorite(_ sender: QMUIButton) {
        if sender.isSelected {
            movie.delete()
        } else {
            movie.save()
        }
        sender.isSelected = !sender.isSelected
    }
    
    @objc fileprivate func pushToBaiduYun(_ sender: QMUIButton) {
        if sender.tag - 1 <= movie.baiduYuns.count {
            if let urlString = movie.baiduYuns[sender.tag].url {
                if let url = URL(string: urlString) {
                    let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
                    present(vc, animated: true, completion: nil)
                }
            }
        }
    }

    // MARK: - 刷新内容
    fileprivate func refreshContent() {
        postImageView.setImage(url: movie.poster ?? movie.homepagePoster)
        infoLabel.attributedText = AppFont.attributeString(kFontRegularName, text: movie.producerInfo, fontSize: 12, fontColor: AppColor.theme.subTitleColor)
        nameLabel.text = movie.name
        infoLabel.sizeToFit()
        
        for (index, _) in movie.baiduYuns.enumerated() {
            let btn = QMUIButton()
            btn.tag = index
            btn.setTitle(" \(index+1) ", for: .normal)
            btn.setTitleColor(AppColor.theme.subTitleColor, for: .normal)
            btn.titleLabel?.font = AppFont.regularFont(14)
            btn.addTarget(self, action: #selector(ZMMovieDetailViewController.pushToBaiduYun(_:)), for: .touchUpInside)
            btn.layer.borderWidth = 1
            btn.layer.borderColor = AppColor.theme.separateYellow.cgColor
            btn.layer.cornerRadius = 6
            floatLayoutView.addSubview(btn)
        }
        
        if let name = movie.name {
            if let movies = ZMMovie.objectsWhere("WHERE name == \"\(name)\"", arguments: nil) as? [ZMMovie] {
                favoriteBtn.isSelected = movies.count != 0
            }
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset
        changeNavigationBarColor(contentOffset: contentOffset)
        if contentOffset.y < 0 {
            postImageView.snp.remakeConstraints {
                $0.width.equalTo(kScreenWidth)
                $0.top.equalTo(scrollView).offset(contentOffset.y)
                $0.left.right.equalTo(scrollView)
                postImageViewHeightConstraint = $0.height.equalTo(postImageViewHeight).constraint
            }
            postImageViewHeightConstraint?.update(offset: postImageViewHeight - contentOffset.y)
        } else {
            postImageView.snp.remakeConstraints {
                $0.width.equalTo(kScreenWidth)
                $0.top.left.right.equalTo(scrollView)
                postImageViewHeightConstraint = $0.height.equalTo(postImageViewHeight).constraint
            }
            postImageViewHeightConstraint?.update(offset: postImageViewHeight)
        }
    }
    
}

// MARK: - 网络
extension ZMMovieDetailViewController {
    
    fileprivate func getMovieDetail() {
//        showLoading()
        Alamofire.request(detailUrl)
            .responseData { [weak self] (response) in
                guard let strongSelf = self else { return }
                strongSelf.hideLoading()
                if response.result.error == nil {
                    if let htmlData = response.result.value {
                        if let doc = TFHpple(htmlData: htmlData) {
                            if let homepagePosterNode = doc.search(withXPathQuery: "//img[@class='img-frame aligncenter']").first as? TFHppleElement {
                                strongSelf.movie.homepagePoster = homepagePosterNode["src"] as? String
                                if let name = homepagePosterNode["alt"] as? String, name != "" {
                                    strongSelf.movie.name = name
                                }
                            }
                            if let homepagePosterNode = doc.search(withXPathQuery: "//img[@class='img-frame  aligncenter']").first as? TFHppleElement {
                                strongSelf.movie.homepagePoster = homepagePosterNode["src"] as? String
                                if let name = homepagePosterNode["alt"] as? String, name != "" {
                                    strongSelf.movie.name = name
                                }
                            }
                            
                            if let content = doc.search(withXPathQuery: "//div[@class='content-box']").first as? TFHppleElement {
                                
                                let strs = content.content.components(separatedBy: "【资源下载】")
                                if strs.count > 0 {
                                    strongSelf.movie.producerInfo = strs[0]
                                }
                                strongSelf.movie.baiduYuns.removeAll()
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

