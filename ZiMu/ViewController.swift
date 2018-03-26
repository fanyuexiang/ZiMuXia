//
//  ViewController.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/25.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: ZMViewController {
    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        button.backgroundColor = .red
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalTo(view)
            $0.width.height.equalTo(100)
        }
        button.addTarget(self, action: #selector(ViewController.click), for: .touchUpInside)
    }
    
    @objc func click() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0, 0.8, 1.0]
        impliesAnimation.duration = 0.2
        impliesAnimation.calculationMode = kCAAnimationCubic
        button.layer.add(impliesAnimation, forKey: nil)
    }
}

