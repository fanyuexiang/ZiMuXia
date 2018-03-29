//
//  ZMUtils.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/25.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation
import UIKit
import QMUIKit

class ZMUtils {
    
    /// 显示/隐藏导航栏底线
    class func showSeparator(_ navigationController : UINavigationController?) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        bottomLineOfNavigationBar(view: navigationBar)?.isHidden = false
    }
    
    class func hideSeparator(_ navigationController : UINavigationController?) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        bottomLineOfNavigationBar(view: navigationBar)?.isHidden = true
    }
    
    fileprivate class func bottomLineOfNavigationBar(view:UIView) -> UIImageView? {
        if view.isKind(of: UIImageView.self) && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        for subView in view.subviews {
            if let imageView = bottomLineOfNavigationBar(view: subView) {
                return imageView
            }
        }
        return nil
    }
    
    /// 获取当前页面
    class func currentTopViewController() -> UIViewController? {
        return QMUIHelper.visibleViewController()
    }
    
    /// 时间戳转日期
    class func getDateStringWithFormat(_ format:String? = "yyyy-MM-dd", timeInterval: Double) -> String {
        let formatter = DateFormatter() //"yyyy-MM-dd HH:mm:ss"
        formatter.dateFormat = format
        return formatter.string(from: Date(timeIntervalSince1970: timeInterval))
    }
    
    class func getDataStringForNIM(timeInterval: Double?) -> String {
        guard let timeInterval = timeInterval else { return "" }
        let currentTime = Date().timeIntervalSince1970
        let timeDifference = Int(currentTime - timeInterval)
        let second = timeDifference / 60
        if second <= 0 {
            return getDateStringWithFormat("HH:mm", timeInterval: timeInterval)
        }
        if second < 60 {
            return getDateStringWithFormat("HH:mm", timeInterval: timeInterval)
        }
        let hours = timeDifference / 3600
        if hours < 24 {
            return getDateStringWithFormat("HH:mm", timeInterval: timeInterval)
        }
        let days = timeDifference / 3600 / 24
        if days < 30 {
            return getDateStringWithFormat("MM-dd", timeInterval: timeInterval)
        }
        let months = timeDifference / 3600 / 24 / 30
        if months < 12 {
            return getDateStringWithFormat("MM-dd", timeInterval: timeInterval)
        }
        //        let years = timeDifference / 3600 / 24 / 30 / 12
        return getDateStringWithFormat("yyyy-MM-dd", timeInterval: timeInterval)
    }
    
    /// 根据颜色，生成UIImage
    class func imageWithColor(_ color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0), cornerRadius: CGFloat = 0) -> UIImage {
        let image = UIImage.qmui_image(with: color, size: size, cornerRadius: cornerRadius)
        return image!
    }
    
}
