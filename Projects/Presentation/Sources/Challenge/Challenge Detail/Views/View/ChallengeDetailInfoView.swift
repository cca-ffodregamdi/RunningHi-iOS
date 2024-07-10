//
//  ChallengeDetailInfoView.swift
//  Presentation
//
//  Created by 유현진 on 5/30/24.
//

import UIKit
import Common
import SnapKit

class ChallengeDetailInfoView: UIView {
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private lazy var challengeInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "챌린지 기본 정보"
        return label
    }()
    
    private lazy var challengeAchievementRateView: ChallengeAchievementRateView = {
        return ChallengeAchievementRateView()
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var goalElementView: ChallengeDetailRecordElementView = {
        return ChallengeDetailRecordElementView()
    }()
    
    private lazy var goalTermBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithRGB(r: 232, g: 235, b: 237)
        return view
    }()
    
    private lazy var termElementView: ChallengeDetailRecordElementView = {
        return ChallengeDetailRecordElementView()
    }()
    
    private lazy var termParticipantsBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithRGB(r: 232, g: 235, b: 237)
        return view
    }()
    
    private lazy var participatedCountElementView: ChallengeDetailRecordElementView = {
        return ChallengeDetailRecordElementView()
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
        
        self.addSubview(contentLabel)
        self.addSubview(challengeInfoTitleLabel)
        
        [goalElementView, goalTermBreakLine, termElementView, termParticipantsBreakLine, participatedCountElementView].forEach{
            stackView.addArrangedSubview($0)
        }
        self.addSubview(stackView)
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        challengeInfoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(challengeInfoTitleLabel.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        [goalTermBreakLine, termParticipantsBreakLine].forEach{
            $0.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
        }
    }
    
    func configureModel(content: String, goal: Float, startDate: String, endDate: String, participatedCount: Int){
        contentLabel.text = content
        goalElementView.configureModel(title: "챌린지 목표", value: "\(goal)")
        termElementView.configureModel(title: "기간", value: Date().formatChallengeTermToMd(dateString: startDate) + " ~ " + Date().formatChallengeTermToMd(dateString: endDate))
        participatedCountElementView.configureModel(title: "참여자", value: "\(participatedCount)명")
    }
    
    func configureAchievementRateView(category: String, isParticipated: Bool, record: Float?, goal: Float?){
        if isParticipated{
            self.addSubview(challengeAchievementRateView)
            var challengeCategoryModel: ChallengeCategory?{
                guard let categoryType = ChallengeCategoryType(rawValue: category) else {
                        return nil
                    }
                    return ChallengeCategory(category: categoryType, record: record ?? 0.0, goal: goal ?? 0.0)
            }
            
            guard let challengeCategoryModel = challengeCategoryModel else { return }
            challengeAchievementRateView.configureModel(challengeCategoryModel: challengeCategoryModel)
            challengeAchievementRateView.snp.makeConstraints { make in
                make.top.equalTo(contentLabel.snp.bottom).offset(20)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            }
            
            challengeInfoTitleLabel.snp.remakeConstraints { make in
                make.top.equalTo(challengeAchievementRateView.snp.bottom).offset(30)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
        }else{
            challengeAchievementRateView.removeFromSuperview()
            challengeInfoTitleLabel.snp.updateConstraints { make in
                make.top.equalTo(contentLabel.snp.bottom).offset(30)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
        }
    }
}
