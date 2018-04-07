//
//  AppDelegate.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/25.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configGlobalAppearance()
        configUMCAnalytics()
        configKeyWindow()
        return true
    }
    
    private func configGlobalAppearance() {
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = AppColor.theme.titleColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font : UIFont(name: kFontMediumName, size: 18.0)!]
    }
    
    private func configUMCAnalytics() {
        #if DEBUG
        // 打开调试日志
        UMConfigure.setLogEnabled(true)
        #endif
        UMConfigure.initWithAppkey("5844e3397666135d78000139", channel: "App Store")
    }
    
    private func configKeyWindow() {
        window?.backgroundColor = .white
        window?.rootViewController = WTTabBarController()
        window?.makeKeyAndVisible()
    }
    
    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }


}

