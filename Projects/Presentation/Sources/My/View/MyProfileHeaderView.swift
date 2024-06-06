//
//  MyProfileHeaderView.swift
//  Presentation
//
//  Created by 유현진 on 5/17/24.
//

import UIKit
import Common
import SnapKit

class MyProfileHeaderView: UIView{
    
    lazy var profileImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = UIColor.colorWithRGB(r: 100, g: 112, b: 125)
        return imageView
    }()
    
    lazy var profileInfoStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var nickNameLabel: UILabel = {
        var label = UILabel()
        label.text = "러닝하이"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    lazy var levelLabel: UILabel = {
        var label = UILabel()
        label.text = "LV.1"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 144, g: 149, b: 161)
        return label
    }()
    
    lazy var editProfileButton: UIButton = {
        var button = UIButton()
        button.setTitle("프로필 수정", for: .normal)
        button.setTitleColor(UIColor.colorWithRGB(r: 130, g: 143, b: 155), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.layer.borderColor = UIColor.colorWithRGB(r: 130, g: 143, b: 155).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.backgroundColor = .systemBackground
        
        self.addSubview(profileImageView)
        self.addSubview(profileInfoStackView)
        self.addSubview(editProfileButton)
        [nickNameLabel, levelLabel].forEach{
            self.profileInfoStackView.addArrangedSubview($0)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        profileInfoStackView.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(12)
            make.top.equalTo(profileImageView.snp.top)
            make.bottom.equalTo(profileImageView.snp.bottom)
        }
        
        editProfileButton.snp.makeConstraints { make in
            make.left.equalTo(profileInfoStackView.snp.right).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.width.equalTo(73)
            make.height.equalTo(32)
        }
        
    }
}
