//
//  Constants.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/25.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation
import UIKit

/// third party

/// size
let kWindow = UIApplication.shared.keyWindow
let kScreenFrame = UIScreen.main.bounds
let kScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let kScreenHeight: CGFloat = UIScreen.main.bounds.size.height
let IPHONE6_SCREEN_WIDTH: CGFloat = 375.0
let IPHONE6_SCREEN_HEIGHT: CGFloat = 667.0
let kNavigationBarHeight: CGFloat = 44.0
let kTabbarHeight: CGFloat = (Device() == .simulator(.iPhoneX) || Device() == .iPhoneX) ? (49.0 + 34.0) : 49.0
let kStatusBarHeight: CGFloat = (Device() == .simulator(.iPhoneX) || Device() == .iPhoneX) ? 44.0 : 20.0
let kTabbarSafeBottomMargin: CGFloat = (Device() == .simulator(.iPhoneX) || Device() == .iPhoneX) ? 34.0 : 0

/// system
let kNotificationCenter = NotificationCenter.default
let kUserDefaults = UserDefaults.standard
let kBundle = Bundle.main
let kApplication = UIApplication.shared
let kAppDelegate = kApplication.delegate as! AppDelegate

/// notification

/// Font
let kFontLightName = "PingFangSC-Light"
let kFontMediumName = "PingFangSC-Medium"
let kFontRegularName = "PingFangSC-Regular"
let kFontSemiboldName = "PingFangSC-Semibold"

/// url routes

/// 语言
let APP_LANGUAGE = "AppLanguage"
/// 中英语
let CHINESE_SIMPLIFIED = "zh-Hans"
let ENGLISH = "en"

/// catch key


/// APP 环境
let APP_ENVIRONMENT = "test"
let APP_SERVER = "http://testinterface.wondertech.com.cn/"

// MARK: - typealias
typealias VoidCallback = (() -> Void)

// MARK:-Public function

/// measure code run time
///
/// - Parameter f: code for measure
func measure(f: ()->()) {
    let start = CACurrentMediaTime()
    f()
    let end = CACurrentMediaTime()
    dPrint("测量时间：\(end - start)")
}

/// debug log
///
/// - Parameter item: any object to log
func dPrint(_ item: @autoclosure () -> Any) {
    #if DEBUG
        print(item())
    #endif
}
/// debug info log
///
/// - Parameter item: any message to log
func dPrint(message: String = "", file: String = #file, function: String = #function, lineNum: Int = #line) {
    #if DEBUG
        let data = Date(timeIntervalSinceNow: 0)
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let dateString = formater.string(from: data)
        print("< \(dateString) \(URL(string: file)!.lastPathComponent),\(function),(\(lineNum)) > \(message)")
    #endif
}
