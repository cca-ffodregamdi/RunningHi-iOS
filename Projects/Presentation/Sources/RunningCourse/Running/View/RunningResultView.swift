//
//  RunningResultView.swift
//  Presentation
//
//  Created by najin on 7/8/24.
//

import UIKit
import SnapKit
import Domain
import Common

class RunningResultView: UIView {
    
    //MARK: - Configure
    
    private var isRunningResult = true
    
    static var horizontalPadding = 20
    
    var titleArea = RunningResultTitleView()
    var dataArea = RunningResultDataView()
    var mapArea = RunningResultMapView()
    var difficultyArea = RunningResultDifficultyView()
    var recordView = RunningResultRecordView()
    
    private lazy var runningResultStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    var saveButton = RunningResultButton(title: "기록 저장하기", isActive: false)
    var shareButton = RunningResultButton(title: "피드 공유하기", isActive: true)
    
    private lazy var buttonStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        return stackView
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(isRunningResult: Bool) {
        super.init(frame: .zero)
        
        self.isRunningResult = isRunningResult
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Configure
    
    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(runningResultStackView)
        runningResultStackView.addArrangedSubview(titleArea)
        runningResultStackView.addArrangedSubview(dataArea)
        runningResultStackView.addArrangedSubview(mapArea)
        runningResultStackView.addArrangedSubview(CustomLineView(height: 8))
        runningResultStackView.addArrangedSubview(difficultyArea)
        runningResultStackView.addArrangedSubview(recordView)
        
        if isRunningResult {
            addSubview(buttonStackView)
            buttonStackView.addArrangedSubview(saveButton)
            buttonStackView.addArrangedSubview(shareButton)
        }
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        runningResultStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(isRunningResult ? 80 : 30)
        }
        
        if isRunningResult {
            buttonStackView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(21)
                make.bottom.equalToSuperview().inset(0)
            }
        }
    }
    
    //MARK: - Helpers
    
    func setData(runningModel: RunningResult) {
        let endTime = DateUtil.getRangedDate(increase: runningModel.runningTime, type: .second, date: runningModel.startTime)

        titleArea.setData(startTime: runningModel.startTime,
                          endTime: endTime,
                          location: runningModel.location,
                          difficulty: isRunningResult ? nil : runningModel.difficulty
        )
        dataArea.setData(time: runningModel.runningTime,
                         calorie: runningModel.calorie,
                         distance: runningModel.distance,
                         pace: runningModel.averagePace
        )
        
        difficultyArea.setDifficulty(level: runningModel.difficulty.level)
    }
}
