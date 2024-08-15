//
//  LoginButtonView.swift
//  Presentation
//
//  Created by 유현진 on 8/15/24.
//

import UIKit
import SnapKit

class LoginButtonView: UIView {

    private lazy var imageView: UIImageView = {
        return UIImageView()
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer()
    }()
    
    init(){
        super.init(frame: .zero)
        configureUI()
        configureTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(12)
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(8)
        }
    }
    
    func configureImageView(image: UIImage){
        self.imageView.image = image
    }
    
    func configureBackgroundColor(color: UIColor){
        self.backgroundColor = color
    }
    
    func configureTitleLabel(textColor: UIColor, font: UIFont){
        self.titleLabel.textColor = textColor
        self.titleLabel.font = font
    }
    
    func setTitleLabelText(text: String){
        self.titleLabel.text = text
    }
    
    func configureTapGesture(){
        self.addGestureRecognizer(tapGesture)
    }
}
