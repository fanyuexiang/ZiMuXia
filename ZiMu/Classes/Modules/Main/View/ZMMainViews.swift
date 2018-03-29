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


/// 渐变view
class ZMGradientView: UIView {
    
    var gradientColor: UIColor = .clear
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        /**
         *  1.通过CAGradientLayer 设置渐变的背景。
         */
        let layer = CAGradientLayer()
        //colors存放渐变的颜色的数组
        layer.colors = [UIColor.white.cgColor,
        gradientColor.withAlphaComponent(0.6).cgColor,
        gradientColor.cgColor]
        /**
         * 起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
         */
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.frame = self.bounds
        self.layer.addSublayer(layer)
    }
    
}

/// Simple view for drawing gradients and borders.
@IBDesignable open class GradientView: UIView {
    
    // MARK: - Types
    
    /// The mode of the gradient.
    @objc public enum Mode: Int {
        /// A linear gradient.
        case linear
        
        /// A radial gradient.
        case radial
    }
    
    
    /// The direction of the gradient.
    @objc public enum Direction: Int {
        /// The gradient is vertical.
        case vertical
        
        /// The gradient is horizontal
        case horizontal
    }
    
    
    // MARK: - Properties
    
    /// An optional array of `UIColor` objects used to draw the gradient. If the value is `nil`, the `backgroundColor`
    /// will be drawn instead of a gradient. The default is `nil`.
    open var colors: [UIColor]? {
        didSet {
            updateGradient()
        }
    }
    
    /// An array of `UIColor` objects used to draw the dimmed gradient. If the value is `nil`, `colors` will be
    /// converted to grayscale. This will use the same `locations` as `colors`. If length of arrays don't match, bad
    /// things will happen. You must make sure the number of dimmed colors equals the number of regular colors.
    ///
    /// The default is `nil`.
    open var dimmedColors: [UIColor]? {
        didSet {
            updateGradient()
        }
    }
    
    /// Automatically dim gradient colors when prompted by the system (i.e. when an alert is shown).
    ///
    /// The default is `true`.
    open var automaticallyDims: Bool = true
    
    /// An optional array of `CGFloat`s defining the location of each gradient stop.
    ///
    /// The gradient stops are specified as values between `0` and `1`. The values must be monotonically increasing. If
    /// `nil`, the stops are spread uniformly across the range.
    ///
    /// Defaults to `nil`.
    open var locations: [CGFloat]? {
        didSet {
            updateGradient()
        }
    }
    
    /// The mode of the gradient. The default is `.Linear`.
    @IBInspectable open var mode: Mode = .linear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The direction of the gradient. Only valid for the `Mode.Linear` mode. The default is `.Vertical`.
    @IBInspectable open var direction: Direction = .vertical {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 1px borders will be drawn instead of 1pt borders. The default is `true`.
    @IBInspectable open var drawsThinBorders: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The top border color. The default is `nil`.
    @IBInspectable open var topBorderColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The right border color. The default is `nil`.
    @IBInspectable open var rightBorderColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    ///  The bottom border color. The default is `nil`.
    @IBInspectable open var bottomBorderColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The left border color. The default is `nil`.
    @IBInspectable open var leftBorderColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    // MARK: - UIView
    
    override open func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let size = bounds.size
        
        // Gradient
        if let gradient = gradient {
            let options: CGGradientDrawingOptions = [.drawsAfterEndLocation]
            
            if mode == .linear {
                let startPoint = CGPoint.zero
                let endPoint = direction == .vertical ? CGPoint(x: 0, y: size.height) : CGPoint(x: size.width, y: 0)
                context?.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: options)
            } else {
                let center = CGPoint(x: bounds.midX, y: bounds.midY)
                context?.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: min(size.width, size.height) / 2, options: options)
            }
        }
        
        let screen: UIScreen = window?.screen ?? UIScreen.main
        let borderWidth: CGFloat = drawsThinBorders ? 1.0 / screen.scale : 1.0
        
        // Top border
        if let color = topBorderColor {
            context?.setFillColor(color.cgColor)
            context?.fill(CGRect(x: 0, y: 0, width: size.width, height: borderWidth))
        }
        
        let sideY: CGFloat = topBorderColor != nil ? borderWidth : 0
        let sideHeight: CGFloat = size.height - sideY - (bottomBorderColor != nil ? borderWidth : 0)
        
        // Right border
        if let color = rightBorderColor {
            context?.setFillColor(color.cgColor)
            context?.fill(CGRect(x: size.width - borderWidth, y: sideY, width: borderWidth, height: sideHeight))
        }
        
        // Bottom border
        if let color = bottomBorderColor {
            context?.setFillColor(color.cgColor)
            context?.fill(CGRect(x: 0, y: size.height - borderWidth, width: size.width, height: borderWidth))
        }
        
        // Left border
        if let color = leftBorderColor {
            context?.setFillColor(color.cgColor)
            context?.fill(CGRect(x: 0, y: sideY, width: borderWidth, height: sideHeight))
        }
    }
    
    override open func tintColorDidChange() {
        super.tintColorDidChange()
        
        if automaticallyDims {
            updateGradient()
        }
    }
    
    override open func didMoveToWindow() {
        super.didMoveToWindow()
        contentMode = .redraw
    }
    
    
    // MARK: - Private
    
    fileprivate var gradient: CGGradient?
    
    fileprivate func updateGradient() {
        gradient = nil
        setNeedsDisplay()
        
        let colors = gradientColors()
        if let colors = colors {
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colorSpaceModel = colorSpace.model
            
            let gradientColors = colors.map { (color: UIColor) -> AnyObject! in
                let cgColor = color.cgColor
                let cgColorSpace = cgColor.colorSpace ?? colorSpace
                
                // The color's color space is RGB, simply add it.
                if cgColorSpace.model == colorSpaceModel {
                    return cgColor as AnyObject!
                }
                
                // Convert to RGB. There may be a more efficient way to do this.
                var red: CGFloat = 0
                var blue: CGFloat = 0
                var green: CGFloat = 0
                var alpha: CGFloat = 0
                color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                return UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor as AnyObject!
                } as NSArray
            
            gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors, locations: locations)
        }
    }
    
    fileprivate func gradientColors() -> [UIColor]? {
        if tintAdjustmentMode == .dimmed {
            if let dimmedColors = dimmedColors {
                return dimmedColors
            }
            
            if automaticallyDims {
                if let colors = colors {
                    return colors.map {
                        var hue: CGFloat = 0
                        var brightness: CGFloat = 0
                        var alpha: CGFloat = 0
                        
                        $0.getHue(&hue, saturation: nil, brightness: &brightness, alpha: &alpha)
                        
                        return UIColor(hue: hue, saturation: 0, brightness: brightness, alpha: alpha)
                    }
                }
            }
        }
        
        return colors
    }
}



