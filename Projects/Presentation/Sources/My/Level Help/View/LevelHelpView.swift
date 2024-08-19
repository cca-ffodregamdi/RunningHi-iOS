//
//  LevelHelpView.swift
//  Presentation
//
//  Created by 유현진 on 8/19/24.
//

import UIKit
import Common
import SnapKit

class LevelHelpView: UIView {

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "달릴수록 레벨업!"
        label.textColor = .BaseBlack
        label.font = .Subhead
        return label
    }()
    
    lazy var cancelButton: UIButton = {
        var button = UIButton()
        button.setImage(CommonAsset.xOutline.image, for: .normal)
        return button
    }()
    
    private lazy var contentLabel: UILabel = {
        var label = UILabel()
        label.font = .Body2Regular
        label.textColor = .BaseBlack
        label.numberOfLines = 0
        label.text = """
각 레벨마다 2km씩 목표 거리가 늘어나는 등차 수열 방식으로 레벨업이 진행됩니다.
레벨업 할 때마다 기존 누적 거리에 새로운 목표 거리가 더해져, 더욱 긴 거리를 정복하는 성취감을 느낄 수 있습니다.
"""
        return label
    }()
    
    private lazy var levelHelpImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.levelHelpShort.image
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 24
        self.clipsToBounds = true
        
        [titleLabel, cancelButton, contentLabel, levelHelpImageView].forEach{
            self.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.left.equalToSuperview().inset(20)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        levelHelpImageView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.height.equalTo(66)
        }
    }
}
