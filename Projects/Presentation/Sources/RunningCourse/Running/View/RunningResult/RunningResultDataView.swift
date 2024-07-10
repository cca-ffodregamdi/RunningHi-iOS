//
//  RunningResultDataView.swift
//  Presentation
//
//  Created by najin on 7/8/24.
//

import UIKit
import SnapKit

class RunningResultDataView: UIView {
    
    //MARK: - Properties
    
    private var timeLabel = RunningInfoCell(title: "시간")
    private var distanceLabel = RunningInfoCell(title: "거리")
    private var averagePaceLabel = RunningInfoCell(title: "평균 페이스")
    private var calorieLabel = RunningInfoCell(title: "소모 칼로리")
    
    private var runningDataStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
//        stackView.distribution = .fillEqually
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
        addSubview(runningDataStackView)
        runningDataStackView.addArrangedSubview(timeLabel)
        runningDataStackView.addArrangedSubview(CustomLineView())
        runningDataStackView.addArrangedSubview(distanceLabel)
        runningDataStackView.addArrangedSubview(CustomLineView())
        runningDataStackView.addArrangedSubview(averagePaceLabel)
        runningDataStackView.addArrangedSubview(CustomLineView())
        runningDataStackView.addArrangedSubview(calorieLabel)
    }
    
    private func setupConstraints() {
        runningDataStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(RunningResultView.horizontalPadding)
        }
    }
}
