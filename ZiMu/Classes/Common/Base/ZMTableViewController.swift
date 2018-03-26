//
//  ZMTableViewController.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/25.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import UIKit
import QMUIKit

class ZMTableViewController: QMUICommonTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCommonBackItem()
    }
    
    // MARK: - 导航栏
    func setupCommonBackItem() {
        let backItem = QMUINavigationButton.barButtonItem(with: UIImage(named: "icon_back_black"), position: .left, target: self, action: #selector(ZMViewController.leftItemAction))
        if let count = navigationController?.viewControllers.count,count > 1 {
            navigationItem.leftBarButtonItem = backItem
        }
    }
    
    @objc func leftItemAction() {
        navigationController?.popViewController(animated: true)
    }
    
    override func navigationBarTintColor() -> UIColor? {
        return AppColor.theme.titleColor
    }
    
    override func navigationBarBackgroundImage() -> UIImage? {
        return ZMUtils.imageWithColor(.white)
    }
    
    override func forceEnableInteractivePopGestureRecognizer() -> Bool {
        return true
    }
    
    // 适配iPhoneX
    public func getSafeAreaInsetsTop() -> CGFloat {
        let device = Device()
        guard let _ = navigationController else {
            return 0
        }
        return (device == .simulator(.iPhoneX) || device == .iPhoneX) ? 88 : 64
    }
    
    public func getSafeAreaInsetsBottom() -> CGFloat {
        let device = Device()
        guard let _ = tabBarController else {
            return 0
        }
        return (device == .simulator(.iPhoneX) || device == .iPhoneX) ? 83 : 49
    }
    
    // toast
    
    deinit {
        kNotificationCenter.removeObserver(self)
        dPrint(self.classForCoder.description()+"控制器销毁")
    }
}
