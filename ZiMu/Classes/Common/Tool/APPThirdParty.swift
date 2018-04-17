//
//  AppThirdParty.swift
//  ZiMu
//
//  Created by fancy on 2018/4/9.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation
import UIKit
import QMUIKit

enum shareType {
    case weChatSession
    case weChatTimeline
    case weibo
    case qqFriend
    case qqZone
    case other
}

enum platformType {
    case weChat
    case qq
    case weibo
    case alipay
    case other
}

class AppThirdParty {
    
    public typealias completionHandler = (_ info: [String: Any]?, _ response: URLResponse?, _ error: Error?) -> Void
    public typealias payCompletionHandler = (_ result: Bool) -> Void
    
    /// regist third account
    class func registAccount() {
        MonkeyKing.registerAccount(.weChat(appID: "wx3089eaac7e69f84e", appKey: "52bae7f7839176f7ad17a10c72dc03ce", miniAppID: nil))
        MonkeyKing.registerAccount(.weibo(appID: "2660912955", appKey: "99231aecca142ac2c0b8646ce966631b", redirectURL: "http://www.sharesdk.cn"))
        MonkeyKing.registerAccount(.qq(appID: "1106830042"))
    }
    
    // MARK:- third party share
    class func share(text: String?, title: String?, description: String?, shareType: shareType) {
        guard let text = text else { return }
        let info = MonkeyKing.Info(
            title: text,
            description: description,
            thumbnail: nil,
            media: nil
        )
        shareInfo(info, shareType: shareType) { result in
            
        }
    }
    
    class func share(image: UIImage?, thumbnail: UIImage?, shareType: shareType) {
        guard let image = image else { return }
        var compressedThumbnail: UIImage?
        if thumbnail != nil {
            if let compressedImage = compress(thumbnail: thumbnail!) {
                compressedThumbnail = compressedImage
            }
        } else {
            if let compressedImage = compress(thumbnail: image) {
                compressedThumbnail = compressedImage
            }
        }
        let info = MonkeyKing.Info(
            title: nil,
            description: nil,
            thumbnail: compressedThumbnail,
            media: .image(image)
        )
        shareInfo(info, shareType: shareType) { result in
            
        }
    }
    
    class func share(url: String?, thumbnail: UIImage?, title: String?, description: String?, shareType: shareType) {
        guard let urlString = url else { return }
        guard let url = URL(string: urlString) else { return }
        
        var compressedThumbnail: UIImage?
        if thumbnail != nil {
            if let compressedImage = compress(thumbnail: thumbnail!) {
                compressedThumbnail = compressedImage
            }
        }
        let info = MonkeyKing.Info(
            title: title,
            description: description,
            thumbnail: compressedThumbnail,
            media: .url(url)
        )
        shareInfo(info, shareType: shareType) { result in
            print(result)
        }
    }
    
    
    
    fileprivate class func shareInfo(_ info: MonkeyKing.Info, shareType: shareType, completionHandler: @escaping MonkeyKing.DeliverCompletionHandler) {
        var message: MonkeyKing.Message?
        switch shareType {
        case .weChatSession:
            message = MonkeyKing.Message.weChat(.session(info: info))
        case .weChatTimeline:
            message = MonkeyKing.Message.weChat(.timeline(info: info))
        case .weibo:
            message = MonkeyKing.Message.weibo(.default(info: info, accessToken: nil))
        case .qqFriend:
            message = MonkeyKing.Message.qq(.friends(info: info))
        case .qqZone:
            message = MonkeyKing.Message.qq(.zone(info: info))
        default:
            break
        }
        
        if let message = message{
            MonkeyKing.deliver(message, completionHandler: completionHandler)
        }
        
    }
    
    // MARK:-OAuth
    class func OAuth(platformType: platformType, completionHandler: @escaping completionHandler) {
        switch platformType {
        case .weChat:
            MonkeyKing.oauth(for: .weChat) { (info, response, error) in
                completionHandler(info, response, error)
            }
        case .qq:
            MonkeyKing.oauth(for: .qq, scope: "get_user_info") { (info, response, error) in
                completionHandler(info, response, error)
                //                guard
                //                    let unwrappedInfo = info,
                //                    let token = unwrappedInfo["access_token"] as? String,
                //                    let openID = unwrappedInfo["openid"] as? String
                //                else {
                //                    return
                //                }
                
            }
        case .weibo:
            MonkeyKing.oauth(for: .weibo) { (info, response, error) in
                completionHandler(info, response, error)
            }
        default:
            break
        }
        
    }
    
    // MARK:-Pay
    class func pay(platformType: platformType, urlString: String, completionHandler: @escaping payCompletionHandler) {
        switch platformType {
        case .weChat:
            let order = MonkeyKing.Order.weChat(urlString: urlString)
            MonkeyKing.deliver(order) { result in
                completionHandler(result)
            }
        case .alipay:
            let order = MonkeyKing.Order.alipay(urlString: urlString, scheme: nil)
            MonkeyKing.deliver(order) { result in
                completionHandler(result)
            }
        default:
            break
        }
    }
    
    
    // MARK:-Additional function
    fileprivate class func compress(thumbnail: UIImage) -> UIImage? {
        if let data = UIImageJPEGRepresentation(thumbnail, 1) {
            if data.count < 30000 { return thumbnail }
        }
        if let imageData = thumbnail.compress(maxLength: 30000) {
            if imageData.count > 30000 {
                if let compressedImage = UIImage(data: imageData) {
                    return compress(thumbnail: compressedImage)
                }
            } else {
                if let compressedImage = UIImage(data: imageData) {
                    return compressedImage
                }
            }
        }
        return nil
    }
    
}

