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
    
    private lazy var welcomeTextLabel: UILabel = {
        let label = UILabel()
        label.text = "러닝하이와 함께 뛰어볼까요?"
        label.numberOfLines = 0
        label.textAlignment = .center
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
        button.configureTitleLabel(textColor: .colorWithRGB(r: 0, g: 0, b: 0, alpha: 0.85), font: UIFont.systemFont(ofSize: 13, weight: .regular))
        return button
    }()
    
    lazy var appleLoginButton: LoginButtonView = {
        let button = LoginButtonView()
        button.configureBackgroundColor(color: .black)
        button.configureImageView(image: CommonAsset.appleLogo.image)
        button.setTitleLabelText(text: "Apple로 시작하기")
        button.configureTitleLabel(textColor: .white, font: UIFont.systemFont(ofSize: 13, weight: .regular))
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
        
        self.addSubview(welcomeTextLabel)
        self.addSubview(loginButtonStackView)
        
        [kakaoLoginButton, appleLoginButton].forEach{
            self.loginButtonStackView.addArrangedSubview($0)
        }
        
        welcomeTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().dividedBy(3.2)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
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
