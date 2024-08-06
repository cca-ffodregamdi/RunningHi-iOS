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
    
    lazy var kakaoLoginButton: UIButton = {
        var configure = UIButton.Configuration.plain()
        configure.background.image = CommonAsset.kakaoLoginButton.image.withRenderingMode(.alwaysOriginal)
        configure.background.imageContentMode = .scaleAspectFit
        let button = UIButton(configuration: configure)
        return button
    }()
    
    lazy var appleLoginButton: UIButton = {
        var configure = UIButton.Configuration.plain()
        configure.background.image = CommonAsset.appleLoginButton.image
        configure.background.imageContentMode = .scaleAspectFill
        let button = UIButton(configuration: configure)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
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
