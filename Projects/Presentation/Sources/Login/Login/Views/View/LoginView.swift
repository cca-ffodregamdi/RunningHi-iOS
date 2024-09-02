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
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.onboardingImage.image
        imageView.alpha = 0.5
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.logoSymbol.image
        return imageView
    }()
    
    private lazy var welcomeTextLabel: UILabel = {
        let label = UILabel()
        label.text = "러닝하이와 함께\n달릴 준비 되셨나요?"
        label.numberOfLines = 0
        label.font = .Headline
        label.textColor = .Primary
        return label
    }()
    
    private lazy var loginButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var kakaoLoginButton: LoginButtonView = {
        let button = LoginButtonView()
        button.configureBackgroundColor(color: .colorWithRGB(r: 254, g: 229, b: 0))
        button.configureImageView(image: CommonAsset.kakaoLogo.image)
        button.setTitleLabelText(text: "카카오로 시작하기")
        button.configureTitleLabel(textColor: .colorWithRGB(r: 0, g: 0, b: 0, alpha: 0.85), font: UIFont.systemFont(ofSize: 14, weight: .regular))
        return button
    }()
    
    lazy var appleLoginButton: LoginButtonView = {
        let button = LoginButtonView()
        button.configureBackgroundColor(color: .black)
        button.configureImageView(image: CommonAsset.appleLogo.image)
        button.setTitleLabelText(text: "Apple로 시작하기")
        button.configureTitleLabel(textColor: .white, font: UIFont.systemFont(ofSize: 14, weight: .regular))
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
        self.backgroundColor = .colorWithRGB(r: 34, g: 101, b: 201, alpha: 0.3)
        self.addSubview(backgroundImageView)
        self.addSubview(logoImageView)
        self.addSubview(welcomeTextLabel)
        self.addSubview(loginButtonStackView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.left.equalToSuperview().inset(40)
            make.width.height.equalTo(100)
        }
        
        welcomeTextLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(-10)
            make.left.equalToSuperview().inset(40)
            
        }
        
        [kakaoLoginButton, appleLoginButton].forEach{
            self.loginButtonStackView.addArrangedSubview($0)
        }
        
        loginButtonStackView.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(welcomeTextLabel.snp.bottom).offset(200)
            make.left.equalToSuperview().offset(44)
            make.right.equalToSuperview().offset(-44)
            make.bottom.equalToSuperview().offset(-80)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(44)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(44)
        }
    }
}
