//
//  RankTableViewCell.swift
//  Presentation
//
//  Created by 유현진 on 5/31/24.
//

import UIKit
import SnapKit
import Common
import Domain

class RankTableViewCell: UITableViewCell {

    static let identifier: String = "rankCell"
    
    private lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 10, g: 10, b: 11)
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = CommonAsset.defaultSmallProfile.image
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 10, g: 10, b: 11)
        return label
    }()
    
    private lazy var recordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 10, g: 10, b: 11)
        return label
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
        rankLabel.text = ""
        nickNameLabel.text = ""
        recordLabel.text = ""
        profileImageView.image = CommonAsset.defaultSmallProfile.image
    }
    
    private func configureUI(){
        self.addSubview(rankLabel)
        self.addSubview(profileImageView)
        self.addSubview(nickNameLabel)
        self.addSubview(recordLabel)
        
        rankLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(30)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.left.equalTo(rankLabel.snp.right).offset(10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(profileImageView.snp.height)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        recordLabel.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(nickNameLabel.snp.right).offset(20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    func configureModel(model: RankModel, challengeCategory: ChallengeCategoryType){
        rankLabel.text = "\(model.rank)"
        nickNameLabel.text = model.nickname
        switch challengeCategory{
        case .ATTENDANCE:
            recordLabel.text = "\(Int(model.record))회"
        case .DISTANCE:
            recordLabel.text = "\(model.record)km"
        case .SPEED:
            recordLabel.text = Int.convertMeanPaceToString(meanPace: Int(model.record))
        }

        if let url = model.profileImageUrl { profileImageView.setImage(urlString: url) }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }
}
