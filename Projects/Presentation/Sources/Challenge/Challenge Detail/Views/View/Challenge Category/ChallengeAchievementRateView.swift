//
//  ChallengeAchievementRateView.swift
//  Presentation
//
//  Created by 유현진 on 7/6/24.
//

import UIKit
import SnapKit
import Common

class ChallengeAchievementRateView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "챌린지 달성률"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var recordLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.colorWithRGB(r: 10, g: 10, b: 11)
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var goalLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.colorWithRGB(r: 130, g: 143, b: 155)
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(titleLabel)
        self.addSubview(recordLabel)
        self.addSubview(goalLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        recordLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        goalLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(recordLabel.snp.right)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func configureModel(record: Int, goal: Int){
        // TODO: 카테고리 별 단위
        // TODO: 초 단위 -> 분으로 변환
        recordLabel.text = "\(record)/ "
        goalLabel.text = "\(goal)"
    }
}
