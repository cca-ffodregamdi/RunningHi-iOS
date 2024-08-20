//
//  AnnounceTableViewCell.swift
//  Presentation
//
//  Created by 유현진 on 8/5/24.
//

import UIKit
import SnapKit
import Common
import Domain

class AnnounceTableViewCell: UITableViewCell {
    
    static let identifier: String = "AnnounceCell"
    
    private lazy var bellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.bellOutline.image
        return imageView
    }()
    
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
    
    private lazy var xmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.xOutline.image
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
        self.addSubview(bellImageView)
        self.addSubview(titleLabel)
        self.addSubview(newBadgeImageView)
        self.addSubview(dateLabel)
        self.addSubview(xmarkImageView)
        
        bellImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(bellImageView.snp.right).offset(10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(bellImageView.snp.right).offset(10)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        newBadgeImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.right.lessThanOrEqualTo(xmarkImageView.snp.left).offset(-20)
            make.width.height.equalTo(20)
        }
        
        xmarkImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    func configureModel(model: AnnounceModel){
        titleLabel.text = model.title
        dateLabel.text = Date().formatNoticeCreateDate(dateString: model.createDate)
        newBadgeImageView.isHidden = model.isRead
    }
}
