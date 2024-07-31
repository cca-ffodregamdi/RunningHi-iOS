//
//  MyRankView.swift
//  Presentation
//
//  Created by 유현진 on 7/10/24.
//

import UIKit
import Common
import Domain
import SnapKit

class MyRankView: UIView{
    private lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 250, g: 250, b: 250)
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.defaultSmallProfile.image
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 250, g: 250, b: 250)
        return label
    }()
    
    private lazy var recordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 250, g: 250, b: 250)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        self.translatesAutoresizingMaskIntoConstraints = false 
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.backgroundColor = UIColor.colorWithRGB(r: 34, g: 101, b: 201)
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
            make.centerY.equalToSuperview()
            make.width.height.equalTo(26)
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
    
    func configureModel(model: RankModel, challengeCategory: String){
        rankLabel.text = "\(model.rank)"
        nickNameLabel.text = model.nickName
        if challengeCategory == "SPEED"{
            recordLabel.text = Int.convertMeanPaceToString(meanPace: Int(model.record))
        }else if challengeCategory == "ATTENDANCE"{
            recordLabel.text = "\(Int(model.record))회"
        }else{
            recordLabel.text = "\(model.record)km"
        }
    }
}
