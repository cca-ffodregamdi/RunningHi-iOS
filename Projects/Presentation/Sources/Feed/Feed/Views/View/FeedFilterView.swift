//
//  FeedFilterView.swift
//  Presentation
//
//  Created by 유현진 on 7/31/24.
//

import UIKit
import Common
import SnapKit

class FeedFilterView: UIView {
    lazy var sortButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = CommonAsset.chevronDownOutline.image.withTintColor(.Neutrals200)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 5

        configuration.background.strokeColor = .Neutrals200
        configuration.background.strokeWidth = 1
        configuration.background.backgroundColor = .BaseWhite
        configuration.cornerStyle = .medium
        
        var titleAttribute = AttributedString.init("최신순")
        titleAttribute.font = .CaptionRegular
        titleAttribute.foregroundColor = UIColor.BaseBlack
        configuration.attributedTitle = titleAttribute
        
        var button = UIButton(configuration: configuration)
        return button
    }()
    
//    lazy var distanceButton: UIButton = {
//        var configuration = UIButton.Configuration.plain()
//        configuration.image = CommonAsset.chevronDownOutline.image.withTintColor(.Neutrals200)
//        configuration.imagePlacement = .trailing
//        configuration.imagePadding = 5
//        
//        configuration.background.strokeColor = .Neutrals200
//        configuration.background.strokeWidth = 1
//        
//        configuration.background.backgroundColor = .BaseWhite
//        configuration.cornerStyle = .medium
//        var titleAttribute = AttributedString.init("전국")
//        titleAttribute.font = .CaptionRegular
//        titleAttribute.foregroundColor = UIColor.BaseBlack
//        configuration.attributedTitle = titleAttribute
//        
//        var button = UIButton(configuration: configuration)
//        return button
//    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(sortButton)
//        self.addSubview(distanceButton)
        
        sortButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
//        distanceButton.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//            make.left.equalTo(sortButton.snp.right).offset(10)
//        }
    }
}
