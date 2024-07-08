//
//  ChallengeTableViewCell.swift
//  Presentation
//
//  Created by 유현진 on 5/28/24.
//

import UIKit
import SnapKit
import Common
import Domain

class ChallengeTableViewCell: UITableViewCell {

    private lazy var challengeThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark")
        return imageView
    }()
    
    private lazy var challengeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "챌린지 제목"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
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
        
        self.addSubview(challengeThumbnailImageView)
        self.addSubview(challengeTitleLabel)
        [paricipatedMemberImageView, paricipatedMemberCountLabel, remainingDateImageView, remainingDateLabel].forEach{
            self.infoStackView.addArrangedSubview($0)
        }
        self.addSubview(infoStackView)
        
        challengeThumbnailImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(self.challengeThumbnailImageView.snp.height)
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
    }
    
    func configureWithMyChallengeModel(model: MyChallengeModel){
        challengeTitleLabel.text = model.title
        paricipatedMemberCountLabel.text = "\(model.participantsCount)명"
        remainingDateLabel.text = "\(model.remainingTime)일 남음"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        challengeTitleLabel.text = ""
        paricipatedMemberCountLabel.text = ""
        remainingDateLabel.text = ""
    }
}
