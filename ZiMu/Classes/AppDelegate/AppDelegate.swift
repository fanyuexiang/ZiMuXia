//
//  AppDelegate.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/25.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configGlobalAppearance()
        configUMCAnalytics()
        configUMPush(launchOptions)
        configKeyWindow()
        configThirdParty()
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
        MobClick.setCrashReportEnabled(true)
    }
    
    private func configUMPush(_ launchOptions: [AnyHashable : Any]?) {
        let entity = UMessageRegisterEntity()
        entity.types = Int(UMessageAuthorizationOptions.badge.rawValue) | Int(UMessageAuthorizationOptions.alert.rawValue) | Int(UMessageAuthorizationOptions.sound.rawValue)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
           
        }
        UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (granted, error) in
            if granted {
                dPrint(message: "注册远程推送")
                UMessage.setAlias("test", type: kUMessageAliasTypeQQ, response: { (response, error) in
                    if error != nil {
                        dPrint(error)
                    } else {
                        dPrint(message: "绑定别名成功")
                    }
                })
            }
        }
    }
    
    private func configKeyWindow() {
        window?.backgroundColor = .white
        window?.rootViewController = WTTabBarController()
        window?.makeKeyAndVisible()
    }
    
    private func configThirdParty() {
        AppThirdParty.registAccount()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return true
    }
    
    // MARK: - 推送相关
    // 注册APNs成功
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        dPrint(message: "device toke: \(deviceTokenString)")
        UMessage.registerDeviceToken(deviceToken)
    }
    
    // 注册APNs失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        dPrint(error)
    }
    
    //iOS10以下使用这两个方法接收通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        UMessage.didReceiveRemoteNotification(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UMessage.didReceiveRemoteNotification(userInfo)
        completionHandler(.newData)
    }
    
    //iOS10新增：处理前台收到通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        guard let trigger = notification.request.trigger else { return }
        if trigger.isKind(of: UNPushNotificationTrigger.self) {
            //应用处于前台时的远程推送接受
            UMessage.didReceiveRemoteNotification(userInfo)
        } else {
            //应用处于前台时的本地推送接受
        }
        completionHandler([.sound,.alert])
    }
    
    //iOS10新增：处理后台点击通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard let trigger = response.notification.request.trigger else { return }
        if trigger.isKind(of: UNPushNotificationTrigger.self) {
            //应用处于后台时的远程推送接受
            UMessage.didReceiveRemoteNotification(userInfo)
        } else {
            //应用处于后台时的本地推送接受
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }


}

