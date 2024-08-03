//
//  PostView.swift
//  Presentation
//
//  Created by 유현진 on 6/8/24.
//

import UIKit
import Common
import SnapKit
import Domain

final class PostView: UIView {
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.defaultSmallProfile.image
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "러닝하이"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.text = "Lv.1"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 34, g: 101, b: 201)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "방금 전"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 130, g: 143, b: 155)
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "러닝하이"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.thumbUpOutline.image, for: .normal)
        button.setImage(CommonAsset.thumbupBlue.image, for: .selected)
        return button
    }()
    
    private lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.annotationOutline.image, for: .normal)
        return button
    }()
    
    private lazy var commentCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
        self.backgroundColor = .systemBackground
        self.addSubview(profileImageView)
        self.addSubview(infoStackView)
        
        [nickNameLabel, levelLabel].forEach{
            self.infoStackView.addArrangedSubview($0)
        }
        
        self.addSubview(buttonStackView)
        [likeButton, likeCountLabel, commentButton, commentCountLabel].forEach{
            self.buttonStackView.addArrangedSubview($0)
        }
        
        self.addSubview(dateLabel)
        self.addSubview(contentLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.left.equalTo(profileImageView.snp.right).offset(15)
            
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.left.greaterThanOrEqualTo(infoStackView.snp.right).offset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.lessThanOrEqualToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func configureModel(model: FeedDetailModel){
        if let profileImageUrl = model.profileImageUrl{
            profileImageView.setImage(urlString: profileImageUrl)
        }
        nickNameLabel.text = model.nickname ?? "러닝하이"
        contentLabel.text = model.postContent
        levelLabel.text = "Lv.\(model.level)"
        dateLabel.text = Date().createDateToString(createDate: model.createDate)
        likeCountLabel.text = "\(model.likeCount)"
        commentCountLabel.text = "\(model.commentCount)"
    }
}
