//
//  ZMMainModels.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/25.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation
import ObjectMapper

/// banner
final class ZMBanner: ZMBaseModel {
    
    var title: String?
    var desc: String?
    var backgroundImage: String?
    var url: String?
    
    func backgroundImageUrl() -> String {
        if let backgroundImage = backgroundImage {
            if let start = backgroundImage.index(of: "h"), let end = backgroundImage.index(of: ")") {
                let range = start..<end
                let mystr = backgroundImage[range]
                return String(mystr)
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
}

/// 电影
final class ZMMovie: ZMBaseModel {
    var name: String?
    var info: String?
    var backgroundImage: String?
    var url: String?
}
