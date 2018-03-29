//
//  ZMMoviePagerViewController.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/27.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation
import QMUIKit

/// 分类详情分页列表
final class ZMMoviePagerViewController: ZMViewController {
    
    fileprivate lazy var pagerController = TYPagerController()
    
    fileprivate lazy var tabBar: TYTabPagerBar = TYTabPagerBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 40))
    
    fileprivate lazy var tvVC = ZMCatListViewController(cat: CAT_USA_TV)
    
    fileprivate lazy var movieVC = ZMCatListViewController(cat: CAT_USA_MOVIE)
    
    fileprivate lazy var documentaryVC = ZMCatListViewController(cat: CAT_USA_DOCUMENTARY)
    
    // data
    fileprivate let titles = [CAT_USA_TV, CAT_USA_MOVIE, CAT_USA_DOCUMENTARY]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "fix英美社"
        setupTabBar()
        setupPagerController()
    }
    
    override func initSubviews() {
        super.initSubviews()
        view.addSubview(tabBar)
        addChildViewController(pagerController)
        view.addSubview(pagerController.view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.snp.makeConstraints {
            $0.top.equalTo(topLayoutGuide.snp.bottom)
            $0.width.equalTo(kScreenWidth)
            $0.centerX.equalTo(view)
            $0.height.equalTo(40)
        }
        
        pagerController.view.snp.makeConstraints {
            $0.top.equalTo(tabBar.snp.bottom).offset(6.adapted)
            $0.left.right.bottom.equalTo(view)
        }
    }
    
    fileprivate func setupTabBar() {
        tabBar.delegate = self
        tabBar.dataSource = self
        tabBar.register(TYTabPagerBarCell.self, forCellWithReuseIdentifier: "TYTabPagerBarCell")
        tabBar.layout.normalTextFont = AppFont.mediumFont(15.adapted)
        tabBar.layout.selectedTextFont = AppFont.mediumFont(20.adapted)
        tabBar.layout.normalTextColor = AppColor.theme.subTitleColor
        tabBar.layout.selectedTextColor = AppColor.theme.titleColor
        tabBar.layout.progressHeight = 2
        tabBar.layout.progressRadius = 2.5
        tabBar.layout.progressWidth = 40.adapted
        tabBar.layout.progressColor = AppColor.theme.separateYellow
        tabBar.reloadData()
    }
    
    fileprivate func setupPagerController() {
        pagerController.dataSource = self
        pagerController.delegate = self
        addChildViewController(pagerController)
        view.addSubview(pagerController.view)
        pagerController.reloadData()
    }
    
}

extension ZMMoviePagerViewController: TYTabPagerBarDelegate, TYTabPagerBarDataSource {
    func numberOfItemsInPagerTabBar() -> Int {
        return titles.count
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, cellForItemAt index: Int) -> UICollectionViewCell & TYTabPagerBarCellProtocol {
        let cell = pagerTabBar.dequeueReusableCell(withReuseIdentifier:"TYTabPagerBarCell", for: index) as! TYTabPagerBarCell
        cell.titleLabel?.text = titles[index]
        return cell
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, widthForItemAt index: Int) -> CGFloat {
        let title = titles[index]
        return pagerTabBar.cellWidth(forTitle: title)
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, didSelectItemAt index: Int) {
        pagerController.scrollToController(at: index, animate: true);
    }
}

extension ZMMoviePagerViewController: TYPagerControllerDataSource, TYPagerControllerDelegate {
    func numberOfControllersInPagerController() -> Int {
        return 3
    }
    
    func pagerController(_ pagerController: TYPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        if index == 0 {
            return tvVC
        } else if index == 1 {
            return movieVC
        } else {
            return documentaryVC
        }
    }
    
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, animated: Bool) {
        tabBar.scrollToItem(from: fromIndex, to: toIndex, animate: animated)
    }
    
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, progress: CGFloat) {
        tabBar.scrollToItem(from: fromIndex, to: toIndex, progress: progress)
    }
}
