//
//  FeedbackDropdownView.swift
//  Presentation
//
//  Created by 유현진 on 8/28/24.
//

import UIKit
import SnapKit
import Common

class FeedbackDropdownView: UIView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Body1Regular
        label.textColor = .Neutrals500
        label.text = "카테고리 선택"
        return label
    }()
    
    private lazy var updownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.chevronDownOutline.image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .Neutrals300
        return imageView
    }()
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        addTapGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.Neutrals500.cgColor
        self.layer.borderWidth = 1
        
        
        [titleLabel, updownImageView].forEach {
            self.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        updownImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    private func addTapGestureRecognizer(){
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func configureFeedbackCategoryText(type: String?){
        if type == nil{
            titleLabel.text = "카테고리 선택"
            titleLabel.textColor = .Neutrals500
        }else{
            titleLabel.text = type
            titleLabel.textColor = .BaseBlack
        }
    }
}
