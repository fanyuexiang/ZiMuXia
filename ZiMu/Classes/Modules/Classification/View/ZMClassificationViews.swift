//
//  ZMClassificationViews.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/26.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import Foundation

/// classification cell
final class ZMClassificationCell: UITableViewCell {
    static let CellIdentifier = "ZMClassificationCell"
    // UI
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.zm_cornerRadiusAdvance(6, rectCornerType: .allCorners)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(textColor: .white, fontSize: 18.adapted, FontName: kFontMediumName, needShadow: true, shadowColor: .lightGray)
        label.backgroundColor = AppColor.theme.separateYellow
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 2
        label.textAlignment = .center
        label.layer.cornerRadius = 20.adapted
        label.clipsToBounds = true
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints {
            $0.top.left.equalTo(self).offset(10.adapted)
            $0.right.bottom.equalTo(self).offset(-10.adapted)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self).offset(-10.adapted)
            $0.left.equalTo(self).offset(30.adapted)
            $0.width.equalTo(100.adapted)
            $0.height.equalTo(40.adapted)
        }
    }
    
    public func setupCell(title: String?, img: String?) {
        titleLabel.text = title
        if let image = img {
            bgImageView.image = UIImage(named: image)
        }
    }
    
}

