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
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var leftVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.colorWithRGB(r: 10, g: 10, b: 11)
        return label
    }()
    
    private lazy var timeLabelTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "시간"
        label.textColor = UIColor.colorWithRGB(r: 164, g: 173, b: 182)
        return label
    }()
    
    private lazy var centerVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var paceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.colorWithRGB(r: 10, g: 10, b: 11)
        return label
    }()
    
    private lazy var paceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "평균 페이스"
        label.textColor = UIColor.colorWithRGB(r: 164, g: 173, b: 182)
        return label
    }()
    
    private lazy var rightVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var calorieLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.colorWithRGB(r: 10, g: 10, b: 11)
        return label
    }()
    
    private lazy var calorieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "소비 칼로리"
        label.textColor = UIColor.colorWithRGB(r: 164, g: 173, b: 182)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.backgroundColor = .systemBackground
        
        [titleLabel, subTitleLabel].forEach{
            self.titleStackView.addArrangedSubview($0)
        }
        
        [timeLabel, timeLabelTitleLabel].forEach{
            self.leftVerticalStackView.addArrangedSubview($0)
        }
        
        [paceLabel, paceTitleLabel].forEach{
            self.centerVerticalStackView.addArrangedSubview($0)
        }
        
        [calorieLabel, calorieTitleLabel].forEach{
            self.rightVerticalStackView.addArrangedSubview($0)
        }
        
        [leftVerticalStackView, centerVerticalStackView, rightVerticalStackView].forEach {
            self.stackView.addArrangedSubview($0)
        }
        
        self.addSubview(titleStackView)
        self.addSubview(stackView)
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func configureModel(){
        titleLabel.text = "용산 근처 사시는 분들 같이 달려요"
        subTitleLabel.text = "같이 달리면 좋을 것 같아요! 같이 달리면 좋을 것 같아요! 같이 달리면 좋을 것 같아요!"
        timeLabel.text = "03:43:06"
        paceLabel.text = "07’30”"
        calorieLabel.text = "1,729kcal"
    }
}
