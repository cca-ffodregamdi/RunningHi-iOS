//
//  RunningResultDifficultyView.swift
//  Presentation
//
//  Created by najin on 7/8/24.
//

import UIKit
import SnapKit
import MapKit

class RunningResultDifficultyView: UIView {
    
    //MARK: - Properties
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "코스 난이도"
        label.font = .Subhead
        label.textColor = .black
        return label
    }()
    
    private var difficulty1Button = RunningDifficultyButton(title: "매우 쉬움")
    private var difficulty2Button = RunningDifficultyButton(title: "")
    private var difficulty3Button = RunningDifficultyButton(title: "보통")
    private var difficulty4Button = RunningDifficultyButton(title: "")
    private var difficulty5Button = RunningDifficultyButton(title: "매우 어려움")
    
    private var difficultyLineView = CustomLineView(color: .Neutrals300)
    
    private var runningDifficultyButtonStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var runningDifficultyStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        return stackView
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Configure
    
    private func setupViews() {
        runningDifficultyButtonStackView.addArrangedSubview(difficulty1Button)
        runningDifficultyButtonStackView.addArrangedSubview(difficulty2Button)
        runningDifficultyButtonStackView.addArrangedSubview(difficulty3Button)
        runningDifficultyButtonStackView.addArrangedSubview(difficulty4Button)
        runningDifficultyButtonStackView.addArrangedSubview(difficulty5Button)
        
        addSubview(runningDifficultyStackView)
        runningDifficultyStackView.addArrangedSubview(titleLabel)
        runningDifficultyStackView.addArrangedSubview(runningDifficultyButtonStackView)
        
        addSubview(difficultyLineView)
    }
    
    private func setupConstraints() {
        runningDifficultyStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(RunningResultView.horizontalPadding)
        }
        
        difficultyLineView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(8)
            make.left.right.equalToSuperview().inset(RunningDifficultyButton.width / 2 + RunningResultView.horizontalPadding)
        }
    }
}
