//
//  RunningResultTitleView.swift
//  Presentation
//
//  Created by najin on 7/8/24.
//

import UIKit
import SnapKit
import Common

class RunningResultTitleView: UIView {
    
    //MARK: - Properties
    
    private var runningNameLabel: UILabel = {
        let label = UILabel()
        label.text = "#월 #일 ###"
        label.font = .Headline
        label.textColor = .black
        return label
    }()
    
    private var runningDateLabel: UILabel = {
        let label = UILabel()
        label.text = "####년 #월 #일 00:00 ~ 00:00"
        label.font = .CaptionRegular
        label.textColor = .Neutrals600
        return label
    }()
    
    private var runningTitleStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
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
        addSubview(runningTitleStackView)
        runningTitleStackView.addArrangedSubview(runningNameLabel)
        runningTitleStackView.addArrangedSubview(runningDateLabel)
    }
    
    private func setupConstraints() {
        runningTitleStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(RunningResultView.horizontalPadding)
        }
    }
    
    //MARK: - Helpers
    
    func setData(startTime: Date, endTime: Date) {
        runningNameLabel.text = startTime.convertDateToFormat(format: "M월 d일 러닝")
        runningDateLabel.text = startTime.convertDateToFormat(format: "yyyy년 M월 d일 HH:mm") + "~ " + endTime.convertDateToFormat(format: "HH:mm")
    }
}

