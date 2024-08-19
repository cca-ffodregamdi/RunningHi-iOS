//
//  NoticeTableViewCell.swift
//  Presentation
//
//  Created by 유현진 on 7/18/24.
//

import UIKit
import SnapKit
import Common
import Domain

final class NoticeTableViewCell: UITableViewCell {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Body1Regular
        label.textColor = .black
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
    
    private lazy var chevronRightImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.chevronRightOutline.image
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        dateLabel.text = ""
        newBadgeImageView.isHidden = false
    }

    private func configureUI(){
        self.selectionStyle = .none
        self.addSubview(titleLabel)
        self.addSubview(newBadgeImageView)
        self.addSubview(dateLabel)
        self.addSubview(chevronRightImage)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        newBadgeImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.right.lessThanOrEqualTo(chevronRightImage.snp.left).offset(-20)
            make.width.height.equalTo(20)
        }
        
        chevronRightImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    func configureModel(noticeModel: NoticeModel){
        titleLabel.text = noticeModel.title
        dateLabel.text = Date().formatNoticeCreateDate(dateString: noticeModel.createDate)
        if Date().isTwoWeeksPassedForNotice(dateString: noticeModel.createDate){
            newBadgeImageView.isHidden = true
        }
    }
}
