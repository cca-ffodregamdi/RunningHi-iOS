//
//  ChallengeCollectionViewCell.swift
//  Presentation
//
//  Created by 유현진 on 8/15/24.
//

import UIKit
import Common
import SnapKit
import Domain

class ChallengeCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "challengeCell"
    
    private lazy var challengeThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "xmark")
        return imageView
    }()
    
    private lazy var challengeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "챌린지 제목"
        label.font = .Subhead
        label.textColor = .black
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var paricipatedMemberImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.userGroupOutline.image
        return imageView
    }()
    
    private lazy var paricipatedMemberCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .CaptionRegular
        label.textColor = .black
        return label
    }()
    
    private lazy var remainingDateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.calendarOutline.image
        return imageView
    }()
    
    private lazy var remainingDateLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .CaptionRegular
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 24
        
        self.addSubview(challengeThumbnailImageView)
        self.addSubview(challengeTitleLabel)
        [paricipatedMemberImageView, paricipatedMemberCountLabel, remainingDateImageView, remainingDateLabel].forEach{
            self.infoStackView.addArrangedSubview($0)
        }
        self.addSubview(infoStackView)
        
        challengeThumbnailImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        challengeTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(self.challengeThumbnailImageView.snp.right).offset(10)
            make.right.lessThanOrEqualToSuperview().offset(-20)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(challengeTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(self.challengeThumbnailImageView.snp.right).offset(10)
            make.right.lessThanOrEqualToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    func configureModel(model: ChallengeModel){
        challengeTitleLabel.text = model.title
        paricipatedMemberCountLabel.text = "\(model.participantsCount)명"
        remainingDateLabel.text = "\(model.remainingTime)일 남음"
        challengeThumbnailImageView.setImage(urlString: model.imageUrl)
    }
    
    func configureWithMyChallengeModel(model: MyChallengeModel){
        challengeTitleLabel.text = model.title
        paricipatedMemberCountLabel.text = "\(model.participantsCount)명"
        remainingDateLabel.text = "\(model.remainingTime)일 남음"
        challengeThumbnailImageView.setImage(urlString: model.imageUrl)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        challengeTitleLabel.text = ""
        paricipatedMemberCountLabel.text = ""
        remainingDateLabel.text = ""
        challengeThumbnailImageView.image = nil
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        challengeThumbnailImageView.layer.cornerRadius = challengeThumbnailImageView.frame.height / 2
    }
}
