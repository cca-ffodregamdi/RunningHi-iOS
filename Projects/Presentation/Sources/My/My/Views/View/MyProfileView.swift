//
//  MyProfileView.swift
//  Presentation
//
//  Created by 유현진 on 8/17/24.
//

import UIKit
import SnapKit
import Common

class MyProfileView: UIView {
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = CommonAsset.defaultLargeProfile.image
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        return stackView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "러닝하이"
        label.font = .Title2
        label.textColor = .BaseBlack
        return label
    }()
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.pencilAltOutline.image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .Neutrals500
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
        self.backgroundColor = .clear
        
        [profileImageView, stackView].forEach{
            self.addSubview($0)
        }
        [nickNameLabel, editProfileButton].forEach{
            self.stackView.addArrangedSubview($0)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(98)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func configureModel(profileImageURL: String?, nickname: String){
        if let url = profileImageURL { profileImageView.setImage(urlString: url)}
        self.nickNameLabel.text = nickname
    }
}
