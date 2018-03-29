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
        imageView.backgroundColor = AppColor.theme.bgLightGrayColor
//        imageView.zm_cornerRadiusAdvance(6, rectCornerType: .allCorners)
        imageView.layer.cornerRadius = 6
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
    
    private lazy var separater: UIView = {
        let separater = UIView()
        separater.backgroundColor = AppColor.theme.separateYellow
        return separater
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
        addSubview(separater)
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
        
        separater.snp.makeConstraints {
            $0.width.equalTo(50.adapted)
            $0.height.equalTo(1)
            $0.centerX.equalTo(self)
            $0.top.equalTo(nameLabel.snp.bottom)
                .offset(3.adapted)
        }
    }
    
    public func setupCell(with data: ZMMovie) {
        backgroundImageView.setImage(url: data.poster)
        nameLabel.text = data.name
        infoLabel.text = data.classification
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

/// search result cell
final class ZMSearchResultCell: UITableViewCell {
    static let CellIdentifier = "ZMSearchResultCell"
    // UI
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_contact_arrow")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(textColor: AppColor.theme.titleColor, fontSize: 16.adapted, FontName: kFontRegularName)
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel(textColor: AppColor.theme.subTitleColor, fontSize: 12.adapted, FontName: kFontRegularName)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.right.equalTo(self).offset(-12.adapted)
            $0.height.equalTo(16.adapted)
            $0.width.equalTo(6.adapted)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(self).offset(12.adapted)
            $0.right.equalTo(arrowImageView.snp.left)
                .offset(-12.adapted)
            $0.left.equalTo(self).offset(20.adapted)
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
                .offset(6.adapted)
            $0.left.equalTo(self).offset(20.adapted)
            $0.right.equalTo(arrowImageView.snp.left)
                .offset(-12.adapted)
        }
    }
    
    private func addViews() {
        addSubview(arrowImageView)
        addSubview(nameLabel)
        addSubview(infoLabel)
    }
    
    public func setupCell(with data: ZMMovie) {
        nameLabel.text = data.name
        infoLabel.text = data.producerInfo
    }
    
}




/// blur view
open class VisualEffectView: UIVisualEffectView {
    
    /// Returns the instance of UIBlurEffect.
    private let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
    
    /**
     Tint color.
     
     The default value is nil.
     */
    open var colorTint: UIColor? {
        get { return _value(forKey: "colorTint") as? UIColor }
        set { _setValue(newValue, forKey: "colorTint") }
    }
    
    /**
     Tint color alpha.
     
     The default value is 0.0.
     */
    open var colorTintAlpha: CGFloat {
        get { return _value(forKey: "colorTintAlpha") as! CGFloat }
        set { _setValue(newValue, forKey: "colorTintAlpha") }
    }
    
    /**
     Blur radius.
     
     The default value is 0.0.
     */
    open var blurRadius: CGFloat {
        get { return _value(forKey: "blurRadius") as! CGFloat }
        set { _setValue(newValue, forKey: "blurRadius") }
    }
    
    /**
     Scale factor.
     
     The scale factor determines how content in the view is mapped from the logical coordinate space (measured in points) to the device coordinate space (measured in pixels).
     
     The default value is 1.0.
     */
    open var scale: CGFloat {
        get { return _value(forKey: "scale") as! CGFloat }
        set { _setValue(newValue, forKey: "scale") }
    }
    
    // MARK: - Initialization
    
    public override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        scale = 1
    }
    
    // MARK: - Helpers
    
    /// Returns the value for the key on the blurEffect.
    private func _value(forKey key: String) -> Any? {
        return blurEffect.value(forKeyPath: key)
    }
    
    /// Sets the value for the key on the blurEffect.
    private func _setValue(_ value: Any?, forKey key: String) {
        blurEffect.setValue(value, forKeyPath: key)
        self.effect = blurEffect
    }
    
}

// ["grayscaleTintLevel", "grayscaleTintAlpha", "lightenGrayscaleWithSourceOver", "colorTint", "colorTintAlpha", "colorBurnTintLevel", "colorBurnTintAlpha", "darkeningTintAlpha", "darkeningTintHue", "darkeningTintSaturation", "darkenWithSourceOver", "blurRadius", "saturationDeltaFactor", "scale", "zoom"]


