//
//  AppFont.swift
//  ZiMu
//
//  Created by fancy on 2018/3/27.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation

//
//  AppFont.swift
//  together
//
//  Created by fancy on 2018/1/29.
//  Copyright © 2018年 wonder Technology Co., Ltd. All rights reserved.
//

import UIKit

/// AppFont Manger
final class AppFont {
    class func regularFont(_ size: CGFloat) -> UIFont {
        return UIFont(name: kFontRegularName, size: size)!
    }
    
    class func lightFont(_ size: CGFloat) -> UIFont {
        return UIFont(name: kFontLightName, size: size)!
    }
    
    class func mediumFont(_ size: CGFloat) -> UIFont {
        return UIFont(name: kFontMediumName, size: size)!
    }
    
    class func semiboldFont(_ size: CGFloat) -> UIFont {
        return UIFont(name: kFontSemiboldName, size: size)!
    }
    
    class func attributeString(_ fontName: String, text: String?, fontSize: CGFloat, fontColor: UIColor) -> NSAttributedString! {
        let font = UIFont(name: fontName, size: fontSize)
        let attributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font: font!, NSAttributedStringKey.foregroundColor: fontColor]
        return NSAttributedString(string: text ?? "", attributes: attributes)
    }
    
    class func mutableAttributedString(_ fontName: String, text: String?, fontSize: CGFloat, fontColor: UIColor) -> NSMutableAttributedString! {
        let font = UIFont(name: fontName, size: fontSize)
        let attributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font : font!, NSAttributedStringKey.foregroundColor : fontColor]
        return NSMutableAttributedString(string: text ?? "", attributes: attributes)
    }
    
    
}

