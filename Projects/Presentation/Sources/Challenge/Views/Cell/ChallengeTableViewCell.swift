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
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var challengeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "챌린지 제목"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
        
    private lazy var distanceAndMemberCountLabel: UILabel = {
        let label = UILabel()
        label.text = "10km"
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
        self.addSubview(challengeThumbnailImageView)
        self.selectionStyle = .none
        [challengeTitleLabel, distanceAndMemberCountLabel].forEach{
            self.infoStackView.addArrangedSubview($0)
        }
        self.addSubview(infoStackView)
        
        challengeThumbnailImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(self.challengeThumbnailImageView.snp.height)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalTo(self.challengeThumbnailImageView.snp.right).offset(10)
            make.right.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    func configureModel(model: ChallengeModel){
        self.challengeTitleLabel.text = model.title
        self.distanceAndMemberCountLabel.text = "\(model.distance)km | \(model.memberCount)명"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
