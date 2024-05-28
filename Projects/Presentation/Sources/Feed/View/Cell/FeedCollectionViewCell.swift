//
//  FeedCollectionViewCell.swift
//  Presentation
//
//  Created by 유현진 on 5/21/24.
//

import UIKit
import SnapKit
import Domain

class FeedCollectionViewCell: UICollectionViewCell {
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark")
        return imageView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "러닝하이"
        return label
    }()
    
    private lazy var dataAndLocationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var createdDateLabel: UILabel = {
        let label = UILabel()
        label.text = "러닝하이"
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "러닝하이"
        return label
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    // TODO: 게시글 이미지 collectionView
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "러닝하이"
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    private lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    
    private lazy var bookMarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    private lazy var bookMarkCountLable: UILabel = {
        let label = UILabel()
        label.text = "0"
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
        self.addSubview(profileImageView)
        self.addSubview(headerStackView)
        [createdDateLabel, locationLabel].forEach{
            self.dataAndLocationStackView.addArrangedSubview($0)
        }
        [nickNameLabel, dataAndLocationStackView].forEach {
            self.headerStackView.addArrangedSubview($0)
        }
        self.addSubview(shareButton)
        self.addSubview(contentLabel)
        self.addSubview(buttonStackView)
        [likeButton, likeCountLabel, commentButton, commentLabel].forEach {
            self.buttonStackView.addArrangedSubview($0)
        }
        self.addSubview(bookMarkButton)
        self.addSubview(bookMarkCountLable)
        
        profileImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
        
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.left.equalTo(profileImageView.snp.right).offset(20)
        }
    
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.top)
            make.bottom.equalTo(headerStackView.snp.bottom)
            make.right.equalToSuperview().offset(-10)
            make.left.equalTo(headerStackView.snp.right).offset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            // TODO: collectionView 추가하면 top 변경
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
        }
        
        bookMarkButton.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.top)
            make.left.equalTo(buttonStackView.snp.right).offset(20)
            make.right.equalTo(bookMarkCountLable.snp.right).offset(-10)
            make.bottom.equalToSuperview()
        }
        
        bookMarkCountLable.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.top)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func reinitForReuse(){
        
    }
    
    func configureModel(model: FeedModel){
        self.nickNameLabel.text = model.nickname
        self.contentLabel.text = model.postContent
        self.locationLabel.text = model.locationName
    }
}
