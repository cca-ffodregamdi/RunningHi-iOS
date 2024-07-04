//
//  ChallengeHeaderView.swift
//  Presentation
//
//  Created by 유현진 on 5/29/24.
//

import UIKit
import SnapKit
import Common

class ChallengeHeaderView: UIView {
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "같은 목표를 가지고 \n함께 달리는 기쁨을 누려보세요!"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = UIColor.colorWithRGB(r: 50, g: 63, b: 73)
        return stackView
    }()
    
    private lazy var leftVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var leftVerticalBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var totalChallengeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var totalChallengeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "전체 챌린지"
        label.textColor = .white
        return label
    }()
    
    private lazy var centerVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var rightVerticalBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var participatingChallengeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var participatingChallengeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "진행 중인 챌린지"
        label.textColor = .white
        return label
    }()
    
    private lazy var rightVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var totalMemberCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var totalMemberTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "전체 참여자"
        label.textColor = .white
        return label
    }()
    
    private lazy var createChallengeButton: UIButton = {
        let button = UIButton()
        button.setTitle("챌린지 만들기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(UIColor.colorWithRGB(r: 250, g: 250, b: 250), for: .normal)
        button.backgroundColor = UIColor.colorWithRGB(r: 34, g: 101, b: 201)
        return button
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
        [totalChallengeCountLabel, totalChallengeTitleLabel].forEach{
            self.leftVerticalStackView.addArrangedSubview($0)
        }
        
        [participatingChallengeCountLabel, participatingChallengeTitleLabel].forEach{
            self.centerVerticalStackView.addArrangedSubview($0)
        }
        
        [totalMemberCountLabel, totalMemberTitleLabel].forEach{
            self.rightVerticalStackView.addArrangedSubview($0)
        }
        
        [leftVerticalStackView, leftVerticalBreakLine, centerVerticalStackView, rightVerticalBreakLine, rightVerticalStackView].forEach{
            self.stackView.addArrangedSubview($0)
        }
        
        leftVerticalBreakLine.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        rightVerticalBreakLine.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        self.addSubview(headerTitleLabel)
        self.addSubview(stackView)
        self.addSubview(createChallengeButton)
        
        headerTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(21)
            make.left.equalToSuperview().offset(20)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.top.equalTo(headerTitleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(80)
            make.right.equalToSuperview().offset(-20)
        }
        
        createChallengeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(30)
            make.bottom.equalToSuperview().offset(-25)
            make.width.equalToSuperview().dividedBy(2.5)
            make.height.equalTo(40)
        }
    }
    
    func configureModel(){
        self.totalChallengeCountLabel.text = "2회"
        self.participatingChallengeCountLabel.text = "2회"
        self.totalMemberCountLabel.text = "1000명"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.stackView.layer.cornerRadius = self.stackView.bounds.height * 0.2
        self.createChallengeButton.layer.cornerRadius = self.createChallengeButton.bounds.height * 0.5
    }
}
