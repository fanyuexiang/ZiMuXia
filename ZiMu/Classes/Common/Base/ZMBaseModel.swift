//
//  ZMBaseModel.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/25.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation
import ObjectMapper

class ZMBaseModel: NSObject, Mappable {
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
    }
}

class ZMCacheModel: GYModelObject, Mappable {
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
    }
    
    override class func dbName() -> String {
        return ""
    }
    
    override class func tableName() -> String {
        return ""
    }
    
    override class func primaryKey() -> String {
        return ""
    }
    
    override class func persistentProperties() -> [Any] {
        return []
    }
}

