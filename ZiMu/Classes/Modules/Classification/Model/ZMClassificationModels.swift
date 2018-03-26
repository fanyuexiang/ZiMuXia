//
//  ZMClassificationModels.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/26.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation
import ObjectMapper

final class ZMPixabayImage: ZMBaseModel {
    /**
     largeImageURL = "https://pixabay.com/get/ea37b40b2cf1023ed1584d05fb1d4e92ea70e6d71cac104497f2c17ea2e5bcbc_1280.jpg";
     previewURL = "https://cdn.pixabay.com/photo/2018/03/23/18/16/at-the-movies-3254453_150.jpg";
     webformatURL = "https://pixabay.com/get/ea37b40b2cf1023ed1584d05fb1d4e92ea70e6d71cac104497f2c17ea2e5bcbc_640.jpg";
     */
    var largeImageURL: String?
    var previewURL: String?
    var webformatURL: String?
    
    override func mapping(map: Map) {
        largeImageURL <- map["largeImageURL"]
        previewURL <- map["previewURL"]
        webformatURL <- map["webformatURL"]
    }

}
