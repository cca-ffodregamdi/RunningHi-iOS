//
//  FeedCollectionViewCell.swift
//  Presentation
//
//  Created by 유현진 on 6/14/24.
//

import UIKit
import SnapKit
import Common
import Domain

class FeedCollectionViewCell: UICollectionViewCell {
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.defaultSmallProfile.image
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "러닝하이"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var likeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.thumbUpOutline.image
        return imageView
    }()
    
    private lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var bookmarkStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var bookmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.bookmarkOutline.image
        return imageView
    }()
    
    private lazy var bookmarkCountLable: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 10, g: 10, b: 11)
        return label
    }()
    
    private lazy var kcalLabel: UILabel = {
        let label = UILabel()
        label.text = "0kcal"
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textColor = UIColor.colorWithRGB(r: 0, g: 0, b: 0)
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "러닝하이"
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
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = .systemBackground
        self.addSubview(thumbnailImageView)
        self.addSubview(profileImageView)
        self.addSubview(nickNameLabel)
 
        [likeImageView, likeCountLabel].forEach{
            self.likeStackView.addArrangedSubview($0)
        }
        
        [bookmarkImageView, bookmarkCountLable].forEach{
            self.bookmarkStackView.addArrangedSubview($0)
        }
        
        [likeStackView, bookmarkStackView].forEach{
            self.verticalStackView.addArrangedSubview($0)
        }
        self.addSubview(verticalStackView)
        self.addSubview(kcalLabel)
        self.addSubview(contentLabel)
        
        thumbnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(24)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.left.equalTo(profileImageView.snp.right).offset(10)
        }
        
        [likeImageView, bookmarkImageView].forEach{
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(20)
            }
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.left.greaterThanOrEqualTo(nickNameLabel.snp.right).offset(10)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        kcalLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentLabel.snp.top).offset(-20)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    func configureModel(model: FeedModel){
        self.nickNameLabel.text = model.nickname ?? "러닝하이"
        self.contentLabel.text = model.postContent
        self.likeCountLabel.text = "\(model.likeCount)"
        self.bookmarkCountLable.text = "\(model.bookmarkCount)"
        self.kcalLabel.text = "\(Int(model.kcal))kcal"
    }
}
