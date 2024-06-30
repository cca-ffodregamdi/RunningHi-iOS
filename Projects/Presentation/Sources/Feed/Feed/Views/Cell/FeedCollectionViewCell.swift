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
import Kingfisher
import RxSwift
import RxCocoa

class FeedCollectionViewCell: UICollectionViewCell {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.bookmarkOutline.image, for: .normal)
        button.setImage(CommonAsset.bookmarkFilled.image, for: .selected)
        button.backgroundColor = UIColor.colorWithRGB(r: 255, g: 255, b: 255, alpha: 0.6)
        button.clipsToBounds = false
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.thumbUpOutline.image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        return imageView
    }()
    
    private lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var commentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.annotationOutline.image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        return imageView
    }()
    
    private lazy var commentCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 10, g: 10, b: 11)
        return label
    }()
    
    private lazy var mainContentLabel: UILabel = {
        let label = UILabel()
        label.text = "0kcal"
        label.adjustsFontSizeToFitWidth = true
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
    
    private lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor.colorWithRGB(r: 0, g: 0, b: 0, alpha: 0.15)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetModelForReuse()
    }
    
    private func configureUI(){
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = .systemBackground
        self.addSubview(thumbnailImageView)
        self.addSubview(profileImageView)
        self.addSubview(nickNameLabel)
        self.addSubview(bookmarkButton)
        
        [likeImageView, likeCountLabel, commentImageView, commentCountLabel].forEach{
            self.buttonStackView.addArrangedSubview($0)
        }
        self.addSubview(contentBackgroundView)
        self.addSubview(buttonStackView)
        self.addSubview(mainContentLabel)
        self.addSubview(contentLabel)
        
        
        thumbnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(24)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.left.equalTo(profileImageView.snp.right).offset(5)
        }
        
        [likeImageView, commentImageView].forEach{
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(20)
            }
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.left.greaterThanOrEqualTo(nickNameLabel.snp.right).offset(10)
            make.width.height.equalTo(35)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-10)
            make.right.lessThanOrEqualToSuperview().offset(-10)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-40)
        }
        
        mainContentLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentLabel.snp.top).offset(-5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        contentBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(mainContentLabel.snp.top).offset(-5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configureModel(model: FeedModel){
        if let url = model.imageUrl{
            self.thumbnailImageView.setImage(urlString: url)
            setContentBackgrondView(isHidden: false)
            setContentColor(color: .white)
        }else{
            if Bool.random(){
                self.backgroundColor = .white
                setContentColor(color: .black)
            }else{
                self.backgroundColor = UIColor.colorWithRGB(r: 34, g: 101, b: 201)
                setContentColor(color: .white)
            }
        }
        
        if let url = model.profileImageUrl{
            self.profileImageView.setImage(urlString: url)
        }
        
        self.nickNameLabel.text = model.nickname ?? "러닝하이"
        self.contentLabel.text = model.postContent
        self.likeCountLabel.text = "\(model.likeCount)"
        self.commentCountLabel.text = "\(model.commentCount)"
        self.mainContentLabel.text = model.mainData
        self.bookmarkButton.isSelected = model.isBookmarked
    }
    
    private func setContentBackgrondView(isHidden: Bool){
        self.contentBackgroundView.isHidden = isHidden
    }

    private func setContentColor(color: UIColor){
        nickNameLabel.textColor = color
        contentLabel.textColor = color
        mainContentLabel.textColor = color
        likeImageView.tintColor = color
        likeCountLabel.textColor = color
        commentImageView.tintColor = color
        commentCountLabel.textColor = color
    }

    private func resetModelForReuse(){
        disposeBag = DisposeBag()
        self.thumbnailImageView.kf.cancelDownloadTask()
        self.thumbnailImageView.image = nil
        
        self.profileImageView.kf.cancelDownloadTask()
        self.profileImageView.image = CommonAsset.defaultSmallProfile.image
        
        self.nickNameLabel.text = ""
        self.contentLabel.text = ""
        self.likeCountLabel.text = ""
        self.commentCountLabel.text = ""
        self.mainContentLabel.text = ""
        
        contentLabel.textColor = .black
        mainContentLabel.textColor = .black
        likeImageView.tintColor = .black
        likeCountLabel.textColor = .black
        commentImageView.tintColor = .black
        commentCountLabel.textColor = .black
        bookmarkButton.isSelected = false
        self.contentBackgroundView.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bookmarkButton.layer.cornerRadius = bookmarkButton.bounds.width / 2
    }
}
