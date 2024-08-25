//
//  EditProfileView.swift
//  Presentation
//
//  Created by 유현진 on 8/23/24.
//

import UIKit
import Common
import SnapKit

class EditProfileView: UIView {

    private lazy var profileImageButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.defaultLargeProfile.image, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 24
        return button
    }()
    
    private lazy var cameraBackgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var cameraImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.cameraOutline.image
        return imageView
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .Body2Regular
        label.textColor = .Neutrals700
        return label
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.Neutrals500.cgColor
//        textField.layer.cornerRadius = 8
//        textField.clipsToBounds = true
        textField.font = .Body1Regular
        textField.textColor = .BaseBlack
        return textField
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var logoutLabel: UILabel = {
        let label = UILabel()
        label.text = "로그아웃"
        label.font = .CaptionRegular
        label.textColor = .Neutrals500
        return label
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var verticalBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = .Neutrals500
        return view
    }()
    
    private lazy var signOutLabel: UILabel = {
        let label = UILabel()
        label.text = "회원탈퇴"
        label.font = .CaptionRegular
        label.textColor = .Neutrals500
        return label
    }()
    
    lazy var signOutButton: UIButton = {
        let button = UIButton()
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
        [profileImageButton, cameraBackgroundView, nicknameLabel, nicknameTextField, bottomStackView].forEach {
            self.addSubview($0)
        }
        cameraBackgroundView.addSubview(cameraImageView)
        
        [logoutLabel, verticalBreakLine, signOutLabel].forEach {
            self.bottomStackView.addArrangedSubview($0)
        }
        
        [logoutButton, signOutButton].forEach {
            self.addSubview($0)
        }
        
        profileImageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(98)
        }
        
        cameraBackgroundView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageButton.snp.bottom)
            make.centerX.equalTo(profileImageButton.snp.right)
            make.width.height.equalTo(32)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.centerX.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(25)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nicknameTextField.snp.top).offset(-10)
            make.left.equalToSuperview().inset(27)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(16)
        }
        
        verticalBreakLine.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.top.bottom.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints { make in
            make.edges.equalTo(logoutLabel)
        }
        
        signOutButton.snp.makeConstraints { make in
            make.edges.equalTo(signOutLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cameraBackgroundView.layer.cornerRadius = cameraBackgroundView.frame.height / 2
    }
}
