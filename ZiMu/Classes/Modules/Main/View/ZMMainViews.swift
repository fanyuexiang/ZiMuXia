//
//  ZMMainViews.swift
//  ZiMu
//
//  Created by fancy on 2018/3/26.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import ESTabBarController_swift

/// 轮播cell
final class ZMMainPagerViewCell: FSPagerViewCell {
    
    static let CellIdentifier = "ZMMainPagerViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(textColor: .white, fontSize: 18.adapted, FontName: kFontMediumName, needShadow: true, shadowColor: AppColor.theme.titleColor)
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel(textColor: .white, fontSize: 14.adapted, FontName: kFontRegularName, needShadow: true, shadowColor: AppColor.theme.titleColor)
        return label
    }()
    
    private lazy var backgroundImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.zm_cornerRadiusAdvance(6.adapted, rectCornerType: .allCorners)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        backgroundColor = .white
        contentView.layer.shadowColor = UIColor.clear.cgColor
        contentView.layer.shadowRadius = 0
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImgView.snp.makeConstraints {
            $0.bottom.centerX.equalTo(self)
            $0.top.equalTo(self).offset(20.adapted)
            $0.width.equalTo(self).offset(-30.adapted)
        }
        
        descLabel.snp.makeConstraints {
            $0.bottom.equalTo(self).offset(-20.adapted)
            $0.left.equalTo(self).offset(20.adapted)
            $0.right.equalTo(self).offset(-12.adapted)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(descLabel.snp.top)
                .offset(-6.adapted)
            $0.left.equalTo(self).offset(20.adapted)
            $0.right.equalTo(self).offset(-12.adapted)
            
        }
    }
    
    private func addSubViews() {
        contentView.addSubview(backgroundImgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
    }
    
    public func setupCell(with data: ZMBanner) {
        titleLabel.text = data.title
        descLabel.text = data.desc
        backgroundImgView.setImage(url: data.backgroundImage)
    }
    
    
}

/// 电影瀑布流cell
final class ZMMovieCollectionViewCell: UICollectionViewCell {
    
    static let CellIdentifier = "ZMMovieCollectionViewCell"
    
    // UI
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.zm_cornerRadiusAdvance(6, rectCornerType: .allCorners)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(textColor: AppColor.theme.titleColor, fontSize: 15.adapted, FontName: kFontSemiboldName)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel(textColor: AppColor.theme.subTitleColor, fontSize: 12.adapted, FontName: kFontRegularName)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var separateLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = AppColor.theme.separateYellow.cgColor
        return layer
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        addSubview(backgroundImageView)
        addSubview(nameLabel)
        contentView.layer.addSublayer(separateLayer)
        addSubview(infoLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.snp.makeConstraints {
            $0.top.left.right.equalTo(self)
            $0.bottom.equalTo(self).offset(-50.adapted)
        }
        
        nameLabel.snp.makeConstraints {
            $0.width.centerX.equalTo(self)
            $0.top.equalTo(backgroundImageView.snp.bottom)
                .offset(10.adapted)
        }
        
        infoLabel.snp.makeConstraints {
            $0.width.centerX.equalTo(self)
            $0.top.equalTo(nameLabel.snp.bottom)
                .offset(6.adapted)
        }
        
        separateLayer.frame = CGRect(x: (self.qmui_width - 50.adapted)/2 , y: nameLabel.qmui_bottom+3, width: 50.adapted, height: 1)
    }
    
    public func setupCell(with data: ZMMovie) {
        backgroundImageView.setImage(url: data.backgroundImage)
        nameLabel.text = data.name
        infoLabel.text = data.info
    }
}


/// 瀑布流header
final class ZMCollectionHeader: UICollectionReusableView {
    static let CellIdentifier = "ZMCollectionHeader"
    
    // UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel(textColor: AppColor.theme.titleColor, fontSize: 18.adapted, FontName: kFontSemiboldName)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(self).offset(-6.adapted)
            $0.right.equalTo(self).offset(-15.adapted)
            $0.left.equalTo(self).offset(15.adapted)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupHeader(with title: String) {
        titleLabel.text = title
    }
    
}

// MARK: - 普通tabBar item
final class WTBaseTabBarItemContentView: ESTabBarItemContentView {
    // badge 动画时长
    fileprivate let animationDuration: Double = 0.3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        renderingMode = .alwaysOriginal
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateLayout() {
        super.updateLayout()
        self.imageView.frame.size = CGSize(width: 30.adapted, height: 30.adapted)
        self.imageView.center = CGPoint.init(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
    }
    
    // badge 动画
    override func badgeChangedAnimation(animated: Bool, completion: (() -> ())?) {
        super.badgeChangedAnimation(animated: animated, completion: nil)
        notificationAnimation()
    }
    
    func notificationAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = animationDuration * 2
        impliesAnimation.calculationMode = kCAAnimationCubic
        self.badgeView.layer.add(impliesAnimation, forKey: nil)
    }
    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    func bounceAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0, 0.8, 1.0]
        impliesAnimation.duration = 0.2
        impliesAnimation.calculationMode = kCAAnimationCubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
    
}
