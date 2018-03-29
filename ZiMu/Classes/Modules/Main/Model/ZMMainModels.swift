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
    
    func mapToMovie() -> ZMMovie {
        let movie = ZMMovie()
        movie.name = title
        movie.poster = backgroundImage
        movie.homepageUrl = url
        return movie
    }
}

/// 电影
final class ZMMovie: ZMBaseModel {
    var name: String?
    var classification: String?
    var poster: String?
    var homepagePoster: String?
    var homepageUrl: String?
    var producerInfo: String?
    var synopsis: String?
    var baiduYuns: [ZMBaiduYun] = [ZMBaiduYun]()
}

final class ZMBaiduYun: ZMBaseModel {
    var title: String?
    var url: String?
}
