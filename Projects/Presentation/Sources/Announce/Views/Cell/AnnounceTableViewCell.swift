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
import RxSwift

class AnnounceTableViewCell: UITableViewCell {
    
    var disposeBag: DisposeBag = DisposeBag()
    
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
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.xOutline.image, for: .normal)
        return button
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
        disposeBag = DisposeBag()
    }

    private func configureUI(){
        self.selectionStyle = .none
        [bellImageView, titleLabel, newBadgeImageView, dateLabel, deleteButton].forEach {
            self.contentView.addSubview($0)
        }
        
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
            make.right.lessThanOrEqualTo(deleteButton.snp.left).offset(-20)
            make.width.height.equalTo(20)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    func configureModel(model: AnnounceModel){
        titleLabel.text = model.title
        dateLabel.text = Date.formatDateForNotice(date: model.createDate)
        newBadgeImageView.isHidden = model.isRead
    }
}
