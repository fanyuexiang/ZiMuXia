//
//  ZMNavigationController.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/25.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import UIKit
import QMUIKit

class ZMNavigationController: QMUINavigationController {

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0{
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return super.navigationController(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
    }

}
