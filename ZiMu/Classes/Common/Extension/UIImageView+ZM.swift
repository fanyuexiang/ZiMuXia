//
//  UIImageView+ZM.swift
//  ZiMu
//
//  Created by fancy on 2018/3/26.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    /// Warning: Memory will rise fast when download a lot of images
    ///
    /// - Kingfisher: https://github.com/onevcat/Kingfisher/issues/531
    /// - Reason: Kingfisher will cache all the downloaded images by default, so it is not surprising that it will take some memory even if you are not displaying the images, especially when you are displaying some large images. Generally, there is no worry about it, since Kingfisher will release these cached memory when a memory warning received.
    /// - Solve: Set the maxMemoryCost property of ImageCache.default to customize it.
    func setImage(url: String?, placeHolder: UIImage? = nil, progressBlock: DownloadProgressBlock? = nil, completionHandler: CompletionHandler? = nil) {
        let url = URL(string: url ?? "")
        self.kf.setImage(with: url, placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))], progressBlock: progressBlock, completionHandler: completionHandler)
    }
    
}

