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
    let dataSource = ["英美社","韩语社","日语社","德语社","法语社"]
    var imageData = [ZMPixabayImage]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        animateTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigation()
        // network
        getBgImage()
    }
    
    override func initTableView() {
        super.initTableView()
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.separatorStyle = .none
        tableView.register(ZMClassificationCell.self, forCellReuseIdentifier: ZMClassificationCell.CellIdentifier)
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
        cell.setupCell(title: dataSource[indexPath.row])
        if imageData.count > 5 {
            cell.setupImageView(with: imageData[indexPath.row])
        }
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

// MARK: - 网络
extension ZMClassificationViewController {
    fileprivate func getBgImage() {
        let q = ""
        let page = 1
        let perPage = 10
        ZMNetWork.shared.getDataFromAPI(requestTarget: PixabayAPI.search(q: q, perPage: perPage, page: page)) { (response, error) in
            if error != nil {
                ZMError.handleError(error)
            } else {
                response?.mapArray(type: ZMPixabayImage.self, key: "hits", callback: {  [weak self] (result) in
                    guard let strongSelf = self else { return }
                    switch result {
                    case .failure(let error):
                        ZMError.handleError(error)
                    case .success(let data):
                        strongSelf.imageData = data
                        strongSelf.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    
}
