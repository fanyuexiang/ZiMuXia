//
//  UILabel+ZM.swift
//  ZiMu
//
//  Created by fancy on 2018/3/26.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    convenience init(textColor:  UIColor, fontSize: CGFloat, FontName: String, needShadow: Bool? = false, shadowColor: UIColor? = .black) {
        self.init()
        self.font = UIFont(name: FontName, size: fontSize)
        self.textColor = textColor
        if needShadow! {
            self.shadowColor = shadowColor?.withAlphaComponent(0.3)
            self.shadowOffset = CGSize(width: 1, height: 1)
        }
        self.sizeToFit()
    }
    
}
