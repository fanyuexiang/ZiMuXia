//
//  ZMMainViewController.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/25.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation
import Alamofire

final class ZMMainViewController: ZMViewController {
    
    fileprivate lazy var banners = [ZMBanner]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBanner()
    }
    
}

// 网络
extension ZMMainViewController {
    fileprivate func getBanner() {
        Alamofire.request("http://www.zimuxia.cn/").responseData { (response) in
            if response.result.error  == nil {
                if let htmlData = response.result.value {
                    if let doc = TFHpple(htmlData: htmlData) {
                        for node in doc.search(withXPathQuery: "//div[@class='section section-text layout-cb']") {
                            let data = node as! TFHppleElement
                            print(data["style"])
                            print((data.search(withXPathQuery: "//a").first as! TFHppleElement).content)
                            print((data.search(withXPathQuery: "//a").first as! TFHppleElement)["href"])
                            print("----------")
                        }
                    }
                }
            }
        }
    }
}
