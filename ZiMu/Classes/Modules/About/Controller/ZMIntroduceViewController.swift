//
//  ZMIntroduceViewController.swift
//  ZiMu
//
//  Created by fancy on 2018/3/27.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import UIKit
import Alamofire

/// 起源
final class ZMIntroduceViewController: ZMViewController {

    fileprivate var text: String = ""
    
    fileprivate lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = AppFont.regularFont(16.adapted)
        textView.textColor = AppColor.theme.subTitleColor
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FIX起源"
        getIntroduce()
    }
    
    override func initSubviews() {
        super.initSubviews()
        view.addSubview(textView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
    }

}

// MARK: - network
extension ZMIntroduceViewController {
    fileprivate func getIntroduce() {
        Alamofire.request("http://www.zimuxia.cn/%e5%85%b3%e4%ba%8efix")
            .responseData { [weak self] (response) in
                guard let strongSelf = self else { return }
                if response.result.error  == nil {
                    if let htmlData = response.result.value {
                        if let doc = TFHpple(htmlData: htmlData) {
                            for node in doc.search(withXPathQuery: "//div[@class='content-box']") {
                                let data = node as! TFHppleElement
                                if let significanceNode = data.search(withXPathQuery: "//div").first as? TFHppleElement {
                                    strongSelf.textView.text = significanceNode.content
                                }
                            }
                    } else {
                        ZMError.handleError(response.result.error)
                    }
                }
            }
        }
    }
}
