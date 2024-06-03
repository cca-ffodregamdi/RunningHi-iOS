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

    private lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 10, g: 10, b: 11)
        return label
    }()
    
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark")
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 10, g: 10, b: 11)
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
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
    
    private func configureUI(){
        self.addSubview(rankLabel)
        self.addSubview(profileImageView)
        self.addSubview(nickNameLabel)
        self.addSubview(distanceLabel)
        
        rankLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
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
        
        distanceLabel.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(nickNameLabel.snp.right).offset(20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    func configureModel(model: RankModel){
        rankLabel.text = "\(model.rank)"
        nickNameLabel.text = model.nickName
        distanceLabel.text = "\(model.distance)"
    }
}
