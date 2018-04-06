//
//  ZMWebViewController.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/4/6.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation

import UIKit
import WebKit
import QMUIKit

class ZMWebViewController: ZMViewController {
    
    private var urlString: String!
    private var url: URL!
    private var htmlString: String!
    private var request: URLRequest!
    
    private lazy var wkWebView: WKWebView = {
        let wkWebView = WKWebView()
        wkWebView.navigationDelegate = self
        wkWebView.sizeToFit()
        return wkWebView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .green
        progressView.trackTintColor = .clear
        return progressView
    }()
    
    private lazy var backItem: UIBarButtonItem = {
        let backItem = QMUINavigationButton.barButtonItem(with: UIImage(named: "icon_back_black"), position: .left, target: self, action: #selector(ZMWebViewController.back))
        return backItem!
    }()
    
    private lazy var closeItem: UIBarButtonItem = {
        let closeItem = QMUINavigationButton.barButtonItem(with: .normal, title: "关闭", position: .none, target: self, action: #selector(ZMWebViewController.close))
        return closeItem!
    }()
    
    override func initSubviews() {
        view.addSubview(wkWebView)
        view.addSubview(progressView)
        addObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let top = getSafeAreaInsetsTop()
        wkWebView.snp.makeConstraints {
            $0.top.equalTo(view).offset(top)
            $0.left.right.bottom.equalTo(view)
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(view).offset(top)
            $0.height.equalTo(3)
            $0.left.right.equalTo(view)
        }
    }
    
    @objc private func back() {
        if wkWebView.canGoBack {
            wkWebView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    
    private func addObserver() {
        wkWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    deinit {
        wkWebView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    public func load(urlString: String?) {
        if let urlString = urlString {
            self.urlString = urlString
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                wkWebView.load(request)
            }
        }
    }
    
    public func load(html: String?) {
        if let html = html {
            self.htmlString = html
            wkWebView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.alpha = 1.0
            progressView.setProgress(Float(wkWebView.estimatedProgress), animated: true)
            if Float(wkWebView.estimatedProgress) >= 1.0{
                //设置动画效果，动画时间长度 1 秒。
                UIView.animate(withDuration: 1, delay:0.01,options:UIViewAnimationOptions.curveEaseOut, animations:{()-> Void in
                    self.progressView.alpha = 0.0
                },completion:{(finished:Bool) -> Void in
                    self.progressView .setProgress(0.0, animated: false)
                })
            }
        }
    }
    
    fileprivate func updateNavigationItems(){
        if wkWebView.canGoBack {
            let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
            
            navigationItem.leftBarButtonItems = [backItem,space,closeItem]
            //            navigationItem.setLeftBarButtonItems(, animated: false)
            
        }else{
            navigationController?
                .interactivePopGestureRecognizer?.isEnabled = true;
            navigationItem.backBarButtonItem = backItem
        }
    }

    override func setNavigationItemsIsInEditMode(_ isInEditMode: Bool, animated: Bool) {
        super.setNavigationItemsIsInEditMode(isInEditMode, animated: animated)
        titleView.needsLoadingView = true
        titleView.loadingView.activityIndicatorViewStyle = .gray
    }
}

extension ZMWebViewController: WKNavigationDelegate {
    
    /// 开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        updateNavigationItems()
        titleView.loadingViewHidden = false
    }
    
    /// 加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateNavigationItems()
        if let webTitle = webView.title, webTitle != "" {
            title = webTitle
            titleView.accessoryType = .none
            titleView.loadingViewHidden = true
        }
    }
}
