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
        label.text = "作品"
        return label
    }()
    
    // data
    let dataSource = [
                       ["title":"英美社", "img":"img_classification_usa"],
                       ["title":"韩语社", "img":"img_classification_korea"],
                       ["title":"日语社", "img":"img_classification_japan"],
                       ["title":"德语社", "img":"img_classification_germany"],
                       ["title":"法语社", "img":"img_classification_france"]]
    
    private var firstAppear: Bool = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        animateTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigation()
    }
    
    override func initTableView() {
        super.initTableView()
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 20.adapted, left: 0, bottom: 20.adapted, right: 0)
        tableView.register(ZMClassificationCell.self, forCellReuseIdentifier: ZMClassificationCell.CellIdentifier)
    }
    
    fileprivate func configNavigation() {
        ZMUtils.hideSeparator(navigationController)
        let leftBarButtonItem = UIBarButtonItem(customView: leftItemLabel)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func animateTableView() {
        if !firstAppear { return }
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        for (index, cell) in cells.enumerated() {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
        }
        firstAppear = false
    }
    
    fileprivate func pushToCatList(with index: Int) {
        if index == 0 {
            navigationController?.pushViewController(ZMMoviePagerViewController(), animated: true)
        } else {
            let catListVC = ZMCatListViewController(cat: getCat(with: index))
            navigationController?.pushViewController(catListVC, animated: true)
        }
    }
    
    fileprivate func getCat(with index: Int) -> String {
        switch index {
        case 0:
            return ""
        case 1:
            return CAT_KOREA
        case 2:
            return CAT_JAPAN
        case 3:
            return CAT_GERMANY
        case 4:
            return CAT_FRANCE
        default:
            return ""
        }
    }
}

// MARK: - tableView delegate & dataSource
extension ZMClassificationViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.adapted
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZMClassificationCell.CellIdentifier, for: indexPath) as! ZMClassificationCell
        cell.setupCell(title: dataSource[indexPath.row]["title"], img: dataSource[indexPath.row]["img"])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToCatList(with: indexPath.row)
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

