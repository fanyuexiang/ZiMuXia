//
//  PixabayAPI.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/26.
//  Copyright © 2018年 Fancy. All rights reserved.
//
// https://pixabay.com/api/
import Foundation

/// 即时通讯相关api
enum PixabayAPI: RequestTarget {
    case search(q: String, perPage: Int, page: Int)
}

extension PixabayAPI {
    var path: String {
        switch self {
        case .search:
            return ""
        }
    }
    
    var method: RequestType {
        return .get
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .search(let q, let per, let page):
            var params = [String : Any]()
            params["q"] = q
            params["key"] = "8497425-e0bcb1a4734275b84b1b8c59e"
            params["lang"] = "zh"
            params["orientation"] = "horizontal"
            params["page"] = page
            params["per_page"] = per
            return params
        }
    }
    
}
