//
//  CommentTableViewCell.swift
//  Presentation
//
//  Created by 유현진 on 6/10/24.
//

import UIKit
import Common
import SnapKit
import Domain
import RxSwift

class CommentTableViewCell: UITableViewCell {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.defaultSmallProfile.image
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nickNameDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 3
        return stackView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor.colorWithRGB(r: 64, g: 71, b: 79)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 130, g: 143, b: 155)
        return label
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 10, g: 10, b: 11)
        return label
    }()
    
    lazy var optionButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.dotsVerticalOutline.image, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.selectionStyle = .none
        
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(nickNameDateStackView)
        
        [nickNameLabel, dateLabel].forEach{
            self.nickNameDateStackView.addArrangedSubview($0)
        }
        
        self.contentView.addSubview(commentLabel)
        self.contentView.addSubview(optionButton)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(35)
        }
        
        nickNameDateStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.left.equalTo(profileImageView.snp.right).offset(10)
        }
        
        optionButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.left.greaterThanOrEqualTo(nickNameDateStackView.snp.right).offset(20)
            make.right.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameDateStackView.snp.bottom).offset(10)
            make.left.equalTo(profileImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = CommonAsset.defaultSmallProfile.image
        nickNameLabel.text = nil
        dateLabel.text = nil
        commentLabel.text = nil
        disposeBag = DisposeBag()
    }
    
    func configureModel(model: CommentModel){
        nickNameLabel.text = model.nickName ?? "러닝하이"
        dateLabel.text = Date().createDateToString(createDate: model.createDate)
        commentLabel.text = model.content
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
}
