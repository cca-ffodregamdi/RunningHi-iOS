//
//  NoticeDetailView.swift
//  Presentation
//
//  Created by 유현진 on 7/18/24.
//

import UIKit
import SnapKit
import Common
import Domain

final class NoticeDetailView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Body1Bold
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var newBadgeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.newBadge.image
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .CaptionRegular
        label.textColor = .Neutrals500
        return label
    }()
    
    private lazy var breakLine: UIView = {
        let view = UIView()
        view.backgroundColor = .Neutrals200
        return view
    }()
    
    private lazy var contentLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.numberOfLines = 0
        label.font = .Body2Regular
        label.textColor = .Neutrals700
        label.backgroundColor = .BaseWhite
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(titleLabel)
        self.addSubview(newBadgeImageView)
        self.addSubview(dateLabel)
        self.addSubview(breakLine)
        self.addSubview(contentLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(newBadgeImageView.snp.left).offset(-5)
        }
        
        newBadgeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.equalToSuperview().offset(20)
            make.right.lessThanOrEqualToSuperview().offset(-20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
        }
        
        breakLine.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(breakLine.snp.bottom)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configureModel(noticeModel: NoticeModel){
        titleLabel.text = noticeModel.title
        dateLabel.text = Date.formatDateForNotice(date: noticeModel.createDate)
        contentLabel.text = noticeModel.content
    }
}
