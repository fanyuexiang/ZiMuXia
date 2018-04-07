//
//  ZMClassificationViews.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/26.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation
import QMUIKit

/// About cell
final class ZMAboutCell: UITableViewCell {
    static let CellIdentifier = "ZMAboutCell"
    // UI
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_contact_arrow")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(textColor: AppColor.theme.titleColor, fontSize: 16.adapted, FontName: kFontRegularName)
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel(textColor: AppColor.theme.subTitleColor, fontSize: 12.adapted, FontName: kFontRegularName)
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
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.left.equalTo(self).offset(20.adapted)
        }
        
        infoLabel.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.right.equalTo(arrowImageView.snp.left)
                .offset(-12.adapted)
        }
    }
    
    private func addViews() {
        addSubview(arrowImageView)
        addSubview(titleLabel)
        addSubview(infoLabel)
    }
    
    public func setupCell(title: String?, info: String?) {
        titleLabel.text = title
        infoLabel.text = info
    }
    
}


/// 轮播cell
final class ZMFounderPagerViewCell: FSPagerViewCell {
    
    static let CellIdentifier = "ZMFounderPagerViewCell"
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(textColor: AppColor.theme.titleColor, fontSize: 24.adapted, FontName: kFontMediumName)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var positionLabel: UILabel = {
        let label = UILabel(textColor: AppColor.theme.subTitleColor, fontSize: 14.adapted, FontName: kFontRegularName)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var signLabel: UILabel = {
        let label = UILabel(textColor: AppColor.theme.subTitleColor, fontSize: 18.adapted, FontName: kFontLightName)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var backgroundImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.zm_cornerRadiusAdvance(6, rectCornerType: .allCorners)
        imageView.image = UIImage(named: "image_founder_bg")
        return imageView
    }()
    
    private lazy var avatarImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 55.adapted
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
            $0.top.centerX.equalTo(self)
            $0.height.equalTo(320.adapted)
            $0.width.equalTo(self).offset(-20.adapted)
        }
        
        avatarImgView.snp.makeConstraints {
            $0.width.height.equalTo(110.adapted)
            $0.centerX.equalTo(self)
            $0.top.equalTo(self).offset(120.adapted)
        }
        
        nameLabel.snp.makeConstraints {
            $0.width.lessThanOrEqualToSuperview()
            $0.centerX.equalTo(self)
            $0.top.equalTo(self).offset(280.adapted)
        }
        
        positionLabel.snp.makeConstraints {
            $0.width.lessThanOrEqualToSuperview()
            $0.centerX.equalTo(self)
            $0.top.equalTo(nameLabel.snp.bottom).offset(30.adapted)
        }
        
        signLabel.snp.makeConstraints {
            $0.width.lessThanOrEqualToSuperview()
            $0.centerX.equalTo(self)
            $0.top.equalTo(positionLabel.snp.bottom)
                .offset(10.adapted)
        }
        
    }
    
    private func addSubViews() {
        contentView.addSubview(backgroundImgView)
        contentView.addSubview(avatarImgView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(positionLabel)
        contentView.addSubview(signLabel)
    }
    
    public func setupCell(with data: ZMFounder) {
//        backgroundImgView.setImage(url: data.avatar)
        avatarImgView.setImage(url: data.avatar)
        nameLabel.text = data.name
        positionLabel.text = data.position
        signLabel.text = data.sign
    }
    
}

/// 底部版本footer
final class ZMAboutFooter: UITableViewHeaderFooterView {
    static let CellIdentifier = "ZMAboutFooter"
    // UI
    private lazy var aboutLabel: QMUILabel = {
        let label = QMUILabel(textColor: AppColor.theme.subTitleColor, fontSize: 12, FontName: kFontLightName)
        label.textAlignment = .center
//        let appBuild = kBundle.infoDictionary?[kCFBundleVersionKey as String] as? String
        let appVersion = kBundle.infoDictionary?["CFBundleShortVersionString"] as? String
        label.text = "© 2018 FIX字幕侠 ZiMu v" + (appVersion ?? "")
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        aboutLabel.snp.makeConstraints {
            $0.top.equalTo(self).offset(20)
            $0.centerX.equalTo(self)
            $0.width.lessThanOrEqualToSuperview()
        }
    }
    
    fileprivate func addViews() {
        addSubview(aboutLabel)
    }
}
