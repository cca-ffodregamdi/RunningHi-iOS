//
//  RankHeaderCellView.swift
//  Presentation
//
//  Created by 유현진 on 5/31/24.
//

import UIKit
import SnapKit
import Common
import Domain

class RankHeaderElementView: UIView {
    
    private lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.clipsToBounds = true
        label.backgroundColor = UIColor.colorWithRGB(r: 188, g: 210, b: 244)
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = CommonAsset.defaultLargeProfile.image
        imageView.layer.borderColor = UIColor.colorWithRGB(r: 188, g: 210, b: 244).cgColor
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.text = "-"
        label.textAlignment = .center
        return label
    }()

    private lazy var recordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.text = "-"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(profileImageView)
        self.addSubview(rankLabel)
        self.addSubview(nickNameLabel)
        self.addSubview(recordLabel)
    
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
//            make.left.equalToSuperview().offset(10)
//            make.right.equalToSuperview().offset(-10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(profileImageView.snp.width)
        }
        
        rankLabel.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(profileImageView.snp.top)
        }
     
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        recordLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configureModel(model: RankModel, challengeCategory: String){
        rankLabel.text = "\(model.rank)"
        nickNameLabel.text = model.nickName == nil ? " " : model.nickName
        
        if challengeCategory == "SPEED"{
            recordLabel.text = Int.convertMeanPaceToString(meanPace: Int(model.record))
        }else if challengeCategory == "ATTENDANCE"{
            recordLabel.text = "\(Int(model.record))회"
        }else{
            recordLabel.text = "\(model.record)km"
        }
    }
    
    func isFirstRanker(){
        rankLabel.backgroundColor = UIColor.colorWithRGB(r: 34, g: 101, b: 201)
        profileImageView.layer.borderColor = UIColor.colorWithRGB(r: 34, g: 101, b: 201).cgColor
        
        profileImageView.snp.updateConstraints { make in
            make.left.right.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        rankLabel.layer.cornerRadius = rankLabel.bounds.width / 2
    }
}
