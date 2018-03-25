//
//  AppDelegate.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/25.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configGlobalAppearance()
        configGlobalKeyboard()
        configKeyWindow()
        return true
    }
    
    private func configGlobalAppearance() {
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = AppColor.theme.titleColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font : UIFont(name: kFontMediumName, size: 18.0)!]
    }

    private func configGlobalKeyboard() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 10
        IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "完成"
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

