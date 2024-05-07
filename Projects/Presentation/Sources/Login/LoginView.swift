//
//  LoginView.swift
//  Presentation
//
//  Created by 유현진 on 5/4/24.
//

import UIKit
import Common
import SnapKit

class LoginView: UIView {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark")
        return imageView
    }()
    
    private lazy var welcomeTextLabel: UILabel = {
        let label = UILabel()
        label.text = "간편하게 로그인하고, 다양한 서비스를 이용해보세요."
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var loginButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.kakaoLoginButton.image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        self.backgroundColor = .systemBackground
        
        self.addSubview(logoImageView)
        self.addSubview(welcomeTextLabel)
        self.addSubview(loginButtonStackView)
        self.loginButtonStackView.addArrangedSubview(kakaoLoginButton)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(72)
        }
        
        welcomeTextLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(60)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        loginButtonStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(welcomeTextLabel.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.width.equalToSuperview()
        }
    }
}
