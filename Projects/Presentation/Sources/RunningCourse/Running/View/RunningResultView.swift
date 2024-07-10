//
//  RunningResultView.swift
//  Presentation
//
//  Created by najin on 7/8/24.
//

import UIKit
import SnapKit

class RunningResultView: UIView {
    
    //MARK: - Configure
    
    static var horizontalPadding = 20
    
    private var titleArea = RunningResultTitleView()
    private var dataArea = RunningResultDataView()
    private var mapArea = RunningResultMapView()
    private var difficultyArea = RunningResultDifficultyView()
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
    
    private var saveButton = RunningResultButton(title: "기록 저장하기", isActive: false)
    private var shareButton = RunningResultButton(title: "피드 공유하기", isActive: true)
    
    private lazy var buttonStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
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
        addSubview(scrollView)
        scrollView.addSubview(runningResultStackView)
        runningResultStackView.addArrangedSubview(titleArea)
        runningResultStackView.addArrangedSubview(dataArea)
        runningResultStackView.addArrangedSubview(mapArea)
        runningResultStackView.addArrangedSubview(CustomLineView(height: 8))
        runningResultStackView.addArrangedSubview(difficultyArea)
        runningResultStackView.addArrangedSubview(recordView)
        
        addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(saveButton)
        buttonStackView.addArrangedSubview(shareButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        runningResultStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(80)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(21)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
