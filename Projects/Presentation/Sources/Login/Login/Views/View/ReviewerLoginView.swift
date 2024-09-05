//
//  ReviewerLoginView.swift
//  Presentation
//
//  Created by najin shin on 9/5/24.
//

import UIKit
import Common
import SnapKit

class ReviewerLoginView: UIView {
    
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
    
    lazy var idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "아이디를 입력해주세요."
        textField.borderStyle = .roundedRect
        textField.font = .Body2Regular
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력해주세요."
        textField.borderStyle = .roundedRect
        textField.font = .Body2Regular
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .Primary
        button.layer.cornerRadius = 5
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .Body2Bold
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
        self.addSubview(logoImageView)
        self.addSubview(welcomeTextLabel)
        self.addSubview(idTextField)
        self.addSubview(passwordTextField)
        self.addSubview(loginButton)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().inset(40)
            make.width.height.equalTo(100)
        }
        
        welcomeTextLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(40)
        }
        
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(welcomeTextLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
    }
}
