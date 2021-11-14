//
//  NewsTableViewCell.swift
//  MeltdownPlatform
//
//  Created by Jie Li on 29/6/20.
//  Copyright © 2020 Meltdown Research. All rights reserved.
//

import UIKit
import Kingfisher

class NewsTableViewCell: UITableViewCell {

    var new: NewsModel? {
        didSet {
            if let new = new {
                titleLabel.text = new.title
                contentLabel.text = new.description
                descLabel.text = new.sourceName + "  ·  " + new.publishedAt.timeAgoString
                
                if let imageUrl = new.imageUrl {
                    headImageView.kf.setImage(with: URL(string: imageUrl))
                    headImageView.snp.remakeConstraints { make in
                        make.trailing.equalTo(bgView).offset(-8)
                        make.centerY.equalTo(bgView)
                        make.width.equalTo(80)
                        make.height.equalTo(80)
                    }
                } else {
                    headImageView.snp.remakeConstraints { make in
                        make.trailing.equalTo(bgView).offset(-8)
                        make.centerY.equalTo(bgView)
                        make.width.equalTo(0)
                        make.height.equalTo(80)
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    
                    self.bgView.layer.cornerRadius = 8
                    self.bgView.layer.masksToBounds = true
                    
                    self.bgView.layer.shadowOffset = CGSize.init(width: 0, height: 0.5)
                    self.bgView.layer.shadowColor = UIColor.black.cgColor
                    self.bgView.layer.shadowOpacity = 0.1
                    self.bgView.layer.masksToBounds = false
                    self.bgView.layer.shadowPath = UIBezierPath(rect: self.bgView.layer.bounds).cgPath
                }
            }
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        headImageView.contentMode = .scaleAspectFill
        headImageView.clipsToBounds = true
        return headImageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.tc.bodyText
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.textColor = UIColor.tc.descText
        contentLabel.font = UIFont.systemFont(ofSize: 12)
        contentLabel.numberOfLines = 4
        return contentLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor.tc.descText
        descLabel.font = UIFont.systemFont(ofSize: 12)
        descLabel.numberOfLines = 1
        return descLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        addSubview(bgView)
        bgView.addSubview(headImageView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(contentLabel)
        bgView.addSubview(descLabel)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        let padding = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(padding)
        }
        headImageView.snp.makeConstraints { (make) in
            make.trailing.equalTo(bgView).offset(-8)
            make.centerY.equalTo(bgView)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(bgView).offset(8)
            make.top.equalTo(bgView).offset(8)
            make.trailing.equalTo(headImageView.snp.leading).offset(-8)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.trailing.equalTo(titleLabel)
        }
        descLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.bottom.equalTo(bgView).offset(-8)
        }
    }
}
