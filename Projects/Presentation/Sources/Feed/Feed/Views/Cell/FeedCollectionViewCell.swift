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
    
    private lazy var bookmarkButton: UIButton = {
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
        bindForColor()
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
        
        self.addSubview(buttonStackView)
        self.addSubview(kcalLabel)
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
        
        kcalLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentLabel.snp.top).offset(-10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    func configureModel(model: FeedModel){
        if let url = model.imageUrl{
            self.thumbnailImageView.setImage(urlString: url)
        }
        
        if let url = model.profileImageUrl{
            self.profileImageView.setImage(urlString: url)
        }
        
        self.nickNameLabel.text = model.nickname ?? "러닝하이"
        self.contentLabel.text = model.postContent
        self.likeCountLabel.text = "\(model.likeCount)"
        self.commentCountLabel.text = "\(model.bookmarkCount)"
        self.kcalLabel.text = "\(Int(model.kcal))kcal"
    }
    
    private func bindForColor() {
        thumbnailImageView.rx.observe(UIImage.self, "image")
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .flatMapLatest { [weak self] image -> Observable<(UIImage, CGRect, CGRect, CGRect, CGRect, CGRect, CGRect, CGRect)> in
                guard let self = self else { return Observable.empty() }
                
                let nickNameLabelRect = self.convert(self.nickNameLabel.frame, to: self.thumbnailImageView)
                let contentLabelRect = self.convert(self.contentLabel.frame, to: self.thumbnailImageView)
                let kcalLabelRect = self.convert(self.kcalLabel.frame, to: self.thumbnailImageView)
                let likeCountLabelRect = self.convert(self.likeCountLabel.frame, to: self.thumbnailImageView)
                let likeImageViewRect = self.convert(self.likeImageView.frame, to: self.thumbnailImageView)
                let commentCountLabelRect = self.convert(self.commentCountLabel.frame, to: self.thumbnailImageView)
                let commentImageViewRect = self.convert(self.commentImageView.frame, to: self.thumbnailImageView)
                
                return Observable.create { observer in
                    DispatchQueue.global(qos: .userInitiated).async {
                        observer.onNext((image, nickNameLabelRect, contentLabelRect, kcalLabelRect, likeCountLabelRect, likeImageViewRect, commentCountLabelRect, commentImageViewRect))
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
            }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] image, nickNameLabelRect, contentLabelRect, kcalLabelRect, likeCountLabelRect, likeImageViewRect, commentCountLabelRect, commentImageViewRect in
                self?.updateTextColor(for: image, nickNameLabelRect: nickNameLabelRect, contentLabelRect: contentLabelRect, kcalLabelRect: kcalLabelRect, likeCountLabelRect: likeCountLabelRect, likeImageViewRect: likeImageViewRect, commentCountLabelRect: commentCountLabelRect, commentImageViewRect: commentImageViewRect)
            }
            .disposed(by: disposeBag)
    }

    private func updateTextColor(for image: UIImage, nickNameLabelRect: CGRect, contentLabelRect: CGRect, kcalLabelRect: CGRect, likeCountLabelRect: CGRect, likeImageViewRect: CGRect, commentCountLabelRect: CGRect, commentImageViewRect: CGRect) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let averageColorForNickName = image.averageColor(in: nickNameLabelRect)
            let averageColorForContent = image.averageColor(in: contentLabelRect)
            let averageColorForKcal = image.averageColor(in: kcalLabelRect)
            let averageColorForLikeCountLabel = image.averageColor(in: likeCountLabelRect)
            let averageColorForLikeImageView = image.averageColor(in: likeImageViewRect)
            let averageColorForCommentImageView = image.averageColor(in: commentImageViewRect)
            let averageColorForCommentLabel = image.averageColor(in: commentCountLabelRect)
            
            DispatchQueue.main.async {
                self.nickNameLabel.textColor = averageColorForNickName?.isDark ?? false ? .white : .black
                self.contentLabel.textColor = averageColorForContent?.isDark ?? false ? .white : .black
                self.kcalLabel.textColor = averageColorForKcal?.isDark ?? false ? .white : .black
                self.likeCountLabel.textColor = averageColorForLikeCountLabel?.isDark ?? false ? .white : .black
                self.likeImageView.tintColor = averageColorForLikeImageView?.isDark ?? false ? .white : .black
                self.commentImageView.tintColor = averageColorForCommentImageView?.isDark ?? false ? .white : .black
                self.commentCountLabel.textColor = averageColorForCommentLabel?.isDark ?? false ? .white : .black
            }
        }
    }
    
    private func resetModelForReuse(){
        self.thumbnailImageView.kf.cancelDownloadTask()
        self.thumbnailImageView.image = nil
        
        self.profileImageView.kf.cancelDownloadTask()
        self.profileImageView.image = CommonAsset.defaultSmallProfile.image
        
        self.nickNameLabel.text = ""
        self.contentLabel.text = ""
        self.likeCountLabel.text = ""
        self.commentCountLabel.text = ""
        self.kcalLabel.text = ""
        
        nickNameLabel.textColor = .black
        contentLabel.textColor = .black
        kcalLabel.textColor = .black
        likeImageView.tintColor = .black
        likeCountLabel.textColor = .black
        commentImageView.tintColor = .black
        commentCountLabel.textColor = .black
        bookmarkButton.isEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bookmarkButton.layer.cornerRadius = bookmarkButton.bounds.width / 2
    }
}
