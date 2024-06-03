//
//  ChallengeDetailHeaderView.swift
//  Presentation
//
//  Created by 유현진 on 5/30/24.
//

import UIKit
import SnapKit
import Common

class ChallengeDetailHeaderView: UIView {

    private lazy var challengeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = UIColor.colorWithRGB(r: 188, g: 201, b: 244)
        return imageView
    }()
    
    private lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("참여하기", for: .normal)
        button.setTitleColor(UIColor.colorWithRGB(r: 250, g: 250, b: 250), for: .normal)
        button.backgroundColor = UIColor.colorWithRGB(r: 34, g: 101, b: 201)
        
        button.setTitle("참여 중", for: .selected)
        button.setTitleColor(UIColor.colorWithRGB(r: 130, g: 143, b: 155), for: .selected)
        //button.backgroundColor = UIColor.colorWithRGB(r: 232, g: 235, b: 237)
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
        self.addSubview(challengeImageView)
        self.addSubview(joinButton)
        
        self.challengeImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.joinButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.width.equalToSuperview().dividedBy(2.1)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        joinButton.layer.cornerRadius = joinButton.bounds.height * 0.5
    }
    
}
