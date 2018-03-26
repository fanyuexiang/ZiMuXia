//
//  ZMTabBarController.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/25.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import UIKit
import ESTabBarController_swift

final class WTTabBarController: ESTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildControllers()
        configTabBar()
    }
    
    fileprivate func setupChildControllers() {
        let msgVC = ZMNavigationController(rootViewController: ZMMainViewController())
        let findVC = ZMNavigationController(rootViewController: ZMClassificationViewController())
        let mineVC = ZMNavigationController(rootViewController: ViewController())
    
        msgVC.tabBarItem = ESTabBarItem.init(WTBaseTabBarItemContentView(), title: nil, image: UIImage(named: "tabbar_movie_def"), selectedImage: UIImage(named: "tabbar_movie_sel"))
        findVC.tabBarItem = ESTabBarItem.init(WTBaseTabBarItemContentView(), title: nil, image: UIImage(named: "tabbar_tv_def"), selectedImage: UIImage(named: "tabbar_tv_sel"))
        mineVC.tabBarItem = ESTabBarItem.init(WTBaseTabBarItemContentView(), title: nil, image: UIImage(named: "tabbar_mine_def"), selectedImage: UIImage(named: "tabbar_mine_sel"))
        viewControllers = [msgVC, findVC, mineVC]
    }
    
    fileprivate func configTabBar() {
        tabBar.backgroundImage = ZMUtils.imageWithColor(.white)
        tabBar.shadowImage = ZMUtils.imageWithColor(.white)
        tabBar.layer.shadowColor = UIColor.qmui_color(withHexString: "#c8c8c8").cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 4
        tabBar.layer.shadowOpacity = 0.35
    }
    
}


