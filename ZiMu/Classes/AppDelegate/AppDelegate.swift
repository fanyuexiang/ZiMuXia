//
//  AppDelegate.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/25.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import UIKit
import UserNotifications
import QMUIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configGlobalAppearance()
        configUMCAnalytics()
        configJPush(launchOptions)
        configKeyWindow()
        configThirdParty()
        
        // 重置脚标
        application.applicationIconBadgeNumber = 0
        JPUSHService.resetBadge()
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
    
    private func configJPush(_ launchOptions: [AnyHashable : Any]?) {
        #if RELEASE
        // RELEASE环境下关闭log
        JPUSHService.setLogOFF()
        #endif
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue) |  Int(JPAuthorizationOptions.sound.rawValue) |  Int(JPAuthorizationOptions.badge.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        #if DEBUG
        JPUSHService.setup(withOption: launchOptions, appKey: "d74dd4ddc25a50fe70ba3c89", channel: "AppStore", apsForProduction: false)
        #else
        JPUSHService.setup(withOption: launchOptions, appKey: "d74dd4ddc25a50fe70ba3c89", channel: "AppStore", apsForProduction: true)
        #endif
        // 用极光收集日志错误信息
        JPUSHService.crashLogON()
        // 添加自定义消息监听
        kNotificationCenter.addObserver(self, selector: #selector(AppDelegate.networkDidReceiveMessage(_:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
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
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    // 注册APNs失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        dPrint(error)
    }
    
    //iOS10以下使用这两个方法接收通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(.newData)
    }
    
    //iOS10新增：处理前台收到通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let _ = notification.request.content.userInfo
        guard let trigger = notification.request.trigger else { return }
        if trigger.isKind(of: UNPushNotificationTrigger.self) {
            //应用处于前台时的远程推送接受
        
        } else {
            //应用处于前台时的本地推送接受
        }
        completionHandler([.sound,.alert])
    }
    
    //iOS10新增：处理后台点击通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let _ = response.notification.request.content.userInfo
        guard let trigger = response.notification.request.trigger else { return }
        if trigger.isKind(of: UNPushNotificationTrigger.self) {
            //应用处于后台时的远程推送接受
        } else {
            //应用处于后台时的本地推送接受
        }
    }
    
    // App 进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        kNotificationCenter.post(name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    // App 进入前台
    func applicationWillEnterForeground(_ application: UIApplication) {
        kNotificationCenter.post(name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        application.applicationIconBadgeNumber = 0
        JPUSHService.resetBadge()
    }
    
}

// 极光推送相关
extension AppDelegate: JPUSHRegisterDelegate {
    /// 在前台收到推送内容, 执行的方法
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        dPrint(userInfo)
        JPUSHService.handleRemoteNotification(userInfo)
    }
    /// 在后台收到推送内容, 执行的方法
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        dPrint(userInfo)
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    /// 极光自定义消息
    /// warning: 后台发送时要添加附加字段 title
    /// 更新通知 title: "更新", 其他通知title随意
    /// - Parameter notification:
    @objc func networkDidReceiveMessage(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            dPrint(userInfo)
            if let extras = userInfo["extras"] as? [String: Any], let title = extras["title"] as? String{
                if title == "更新" {
                    updateApp(userInfo)
                } else {
                    showNotificationAlert(userInfo)
                }
            }
        }
    }
    
    // 其他通知
    private func showNotificationAlert(_ userInfo: [AnyHashable : Any]) {
        if let content = userInfo["content"] as? String {
            if let extras = userInfo["extras"] as? [String: Any] {
                if let title = extras["title"] as? String {
                    dPrint(message: "\(content)")
                    dPrint(message: "\(title)")
                    ZMUtils.showAlert(with: title, message: content, actionTitle: "知道了") {_ in }
                }
            }
        }
    }
    
    // 更新app通知
    private func updateApp(_ userInfo: [AnyHashable : Any]) {
        if let content = userInfo["content"] as? String {
            if let extras = userInfo["extras"] as? [String: Any] {
                if let title = extras["title"] as? String {
                    dPrint(message: "\(content)")
                    dPrint(message: "\(title)")
                    ZMUtils.showConfirmOrCancelAlert(with: title, message: content, actionTitle: "好的", cancelTitle: "取消") { (_) in
                        kApplication.openURL(URL(string: APP_STORE_DOWNLOAD_URL)!)
                    }
                }
            }
        }
    }
}
