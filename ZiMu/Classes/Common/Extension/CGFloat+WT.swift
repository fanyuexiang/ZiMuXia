//
//  CGFloat+WT.swift
//  together
//
//  Created by fancy on 2018/1/29.
//  Copyright © 2018年 wonder Technology Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    var adapted: CGFloat {
        return kScreenWidth*self/IPHONE6_SCREEN_WIDTH
    }
    
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    //  Random CGFloat between two CGFloat values.
    ///
    /// - Parameters:
    ///   - min: minimum number to start random from.
    ///   - max: maximum number random number end before.
    /// - Returns: random CGFloat between two CGFloat values.
    public static func randomBetween(min: CGFloat, max: CGFloat) -> CGFloat {
        let delta = max - min
        return min + CGFloat(arc4random_uniform(UInt32(delta)))
    }
}

extension Double {
    var adapted: CGFloat {
        return CGFloat(self).adapted
    }
}

extension Int {
    var adapted: CGFloat {
        return CGFloat(self).adapted
    }
}
