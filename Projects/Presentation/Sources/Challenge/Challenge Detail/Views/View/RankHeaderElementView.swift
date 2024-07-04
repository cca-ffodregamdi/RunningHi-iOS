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
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.colorWithRGB(r: 217, g: 217, b: 217)
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.text = "1"
        return label
    }()

    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.text = "1"
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
        self.addSubview(rankLabel)
        self.addSubview(profileImageView)
        self.addSubview(nickNameLabel)
        self.addSubview(distanceLabel)
        
        rankLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(rankLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(profileImageView.snp.height)
        }
     
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configureModel(model: RankModel){
        rankLabel.text = "\(model.rank)"
        nickNameLabel.text = model.nickName
        distanceLabel.text = "\(model.distance)km"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }
}
