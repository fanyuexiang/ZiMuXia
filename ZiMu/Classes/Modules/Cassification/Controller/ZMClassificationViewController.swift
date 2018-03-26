//
//  ZMClassificationViewController.swift
//  ZiMu
//
//  Created by fancy on 2018/3/26.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation

/// 分类
final class ZMClassificationViewController: ZMTableViewController {
    // UI
    private lazy var leftItemLabel: UILabel = {
        let label = UILabel(textColor: AppColor.theme.titleColor, fontSize: 26.adapted, FontName: kFontMediumName)
        label.frame = CGRect(x: 0, y: 0, width: 60.adapted, height: 44)
        label.text = "分类"
        return label
    }()
    
    // data
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigation()
    }
    
    override func initTableView() {
        super.initTableView()
    }
    
    fileprivate func configNavigation() {
        ZMUtils.hideSeparator(navigationController)
        let leftBarButtonItem = UIBarButtonItem(customView: leftItemLabel)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
}

// MARK: - tableView delegate & dataSource
extension ZMClassificationViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
        leftItemLabel.transform = CGAffineTransform.init(scaleX: scale, y: scale)
    }
    
}
