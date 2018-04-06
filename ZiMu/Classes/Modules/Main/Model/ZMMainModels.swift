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
final class ZMMovie: ZMCacheModel {
    @objc dynamic var name: String?
    @objc dynamic var classification: String?
    @objc dynamic var poster: String?
    @objc dynamic var homepagePoster: String?
    @objc dynamic var homepageUrl: String?
    @objc dynamic var producerInfo: String?
    @objc dynamic var synopsis: String?
    @objc dynamic var baiduYuns: [ZMBaiduYun] = [ZMBaiduYun]()
    
    override class func dbName() -> String {
        return "ZiMu_Data"
    }
    
    override class func tableName() -> String {
        return "ZiMu_Collection_Movies"
    }
    
    override class func primaryKey() -> String {
        return "name"
    }
    
    override class func persistentProperties() -> [Any] {
        return ["name", "classification","poster","homepagePoster","homepageUrl","producerInfo","synopsis"]
    }
    
    public func copy() -> ZMMovie {
        let movie = ZMMovie()
        movie.name = name
        movie.classification = classification
        movie.poster = poster
        movie.homepagePoster = homepagePoster
        movie.homepageUrl = homepageUrl
        movie.producerInfo = producerInfo
        movie.synopsis = synopsis
        movie.baiduYuns = baiduYuns
        return movie
    }
}

final class ZMBaiduYun: ZMCacheModel {
    @objc var title: String?
    @objc var url: String?
}
