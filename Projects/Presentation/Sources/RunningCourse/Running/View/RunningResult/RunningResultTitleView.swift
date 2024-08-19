//
//  RunningResultTitleView.swift
//  Presentation
//
//  Created by najin on 7/8/24.
//

import UIKit
import SnapKit
import Common
import Domain

class RunningResultTitleView: UIView {
    
    //MARK: - Properties
    
    private var runningNameLabel: UILabel = {
        let label = UILabel()
        label.text = "#월 #일 ###"
        label.font = .Headline
        label.textColor = .black
        return label
    }()
    
    private lazy var difficultyLabel: DifficultyLabel = {
        let label = DifficultyLabel()
        label.font = .CaptionRegular
        return label
    }()
    
    private var runningDateLabel: UILabel = {
        let label = UILabel()
        label.text = "####년 #월 #일 00:00 ~ 00:00"
        label.font = .CaptionRegular
        label.textColor = .Neutrals600
        return label
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
        addSubview(runningNameLabel)
        addSubview(runningDateLabel)
        addSubview(difficultyLabel)
    }
    
    private func setupConstraints() {
        runningNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(RunningResultView.horizontalPadding)
        }
        
        difficultyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.left.equalTo(runningNameLabel.snp.right).offset(8)
        }
        
        runningDateLabel.snp.makeConstraints { make in
            make.top.equalTo(runningNameLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(RunningResultView.horizontalPadding)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
    func setData(startTime: Date, endTime: Date, location: String, difficulty: FeedDetailDifficultyType?) {
        runningNameLabel.text = startTime.convertDateToFormat(format: "M월 d일 ") + location + " 러닝"
        runningDateLabel.text = startTime.convertDateToFormat(format: "yyyy년 M월 d일 HH:mm") + "~ " + endTime.convertDateToFormat(format: "HH:mm")
        
        if let difficulty = difficulty {
            difficultyLabel.setTitle(difficulty: difficulty)
        }
        difficultyLabel.isHidden = (difficulty == nil)
    }
}

