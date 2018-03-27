//
//  ZMClassificationViewController.swift
//  ZiMu
//
//  Created by fancy on 2018/3/26.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation
import Kingfisher
import QMUIKit
import AcknowList

/// 分类
final class ZMAboutViewController: ZMTableViewController {
    // UI
    private lazy var leftItemLabel: UILabel = {
        let label = UILabel(textColor: AppColor.theme.titleColor, fontSize: 26.adapted, FontName: kFontMediumName)
        label.frame = CGRect(x: 0, y: 0, width: 60.adapted, height: 44)
        label.text = "关于"
        return label
    }()
    
    // data
    let dataSource = [[["title":"我的收藏"],
                       ["title":"清除缓存"]],
                       [["title":"FIX起源"],
                       ["title":"FIX创始人"]],
                       [["title":"版权声明"],
                       ["title":"开源协议"]]]
    private var totalSize: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        refreshTotalCacheSize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigation()
    }
    
    func refreshTotalCacheSize() {
        ImageCache.default.calculateDiskCacheSize { [weak self]  bytes in
            guard let strongSelf = self else { return }
            strongSelf.totalSize = Int(bytes/1024/1024)
            strongSelf.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }
    }
    
    override func initTableView() {
        super.initTableView()
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.contentInset = UIEdgeInsets(top: 20.adapted, left: 0, bottom: 20.adapted, right: 0)
        tableView.register(ZMAboutCell.self, forCellReuseIdentifier: ZMAboutCell.CellIdentifier)
    }
    
    fileprivate func configNavigation() {
        ZMUtils.hideSeparator(navigationController)
        let leftBarButtonItem = UIBarButtonItem(customView: leftItemLabel)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func animateTableView() {
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        for (index, cell) in cells.enumerated() {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
        }
    }
    
    // MARK: - 操作
    fileprivate func deleteCache() {
        let cancelAction = QMUIAlertAction(title: "取消", style: .cancel) { (_) in }
        let confirmAction = QMUIAlertAction(title: "确定", style: .destructive) { [weak self] _ in
            guard let strongSelf = self else { return }
            QMUITips.showLoading("正在清理", detailText: nil, in: strongSelf.view)
            ImageCache.default.clearDiskCache {
                QMUITips.hideAllTips(in: strongSelf.view)
                strongSelf.refreshTotalCacheSize()
            }
        }
        let alertController = QMUIAlertController(title: "", message: "确定清除？", preferredStyle: .actionSheet)
        alertController?.addAction(cancelAction)
        alertController?.addAction(confirmAction)
        alertController?.showWith(animated: true)
    }
    
    fileprivate func copyrightDeclaration() {
        let alertController = QMUIAlertController(title: "版权声明", message: "所有内容均来自互联网分享站点所提供的公开引用资源", preferredStyle: .alert)
        let cancelAction = QMUIAlertAction(title: "确定", style: .cancel) { (_) in }
        alertController?.addAction(cancelAction)
        alertController?.showWith(animated: true)
    }
    
    fileprivate func publicLicense() {
        let path = Bundle.main.path(forResource: "Pods-ZiMu-acknowledgements", ofType: "plist")
        let viewController = AcknowListViewController(acknowledgementsPlistPath: path)
        viewController.title = "致谢"
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - tableView delegate & dataSource
extension ZMAboutViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.adapted
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.adapted
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZMAboutCell.CellIdentifier, for: indexPath) as! ZMAboutCell
        let size = (indexPath.section == 0 && indexPath.row == 1) ? "\(totalSize)M" : ""
        cell.setupCell(title: dataSource[indexPath.section][indexPath.row]["title"], info: size)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                
            } else {
                deleteCache()
            }
        case 1:
            if indexPath.row == 0 {
                navigationController?.pushViewController(ZMIntroduceViewController(), animated: true)
            } else {
                navigationController?.pushViewController(ZMFoundersViewController(), animated: true)
            }
        default:
            if indexPath.row == 0 {
                copyrightDeclaration()
            } else {
                publicLicense()
            }
        }
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


