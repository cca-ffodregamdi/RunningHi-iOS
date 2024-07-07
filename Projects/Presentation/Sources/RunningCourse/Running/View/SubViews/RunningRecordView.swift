//
//  RunningRecordView.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import UIKit
import SnapKit
import Common

class RunningRecordView: UIView {
    
    //MARK: - Properties
    
    private var timeLabel = RunningInfoCell()
    private var averagePaceLabel = RunningInfoCell()
    private var calorieLabel = RunningInfoCell()
    
    private var recordInfoStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "00.00"
        label.font = .systemFont(ofSize: 80, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private var unitLabel: UILabel = {
        let label = UILabel()
        label.text = "km"
        label.font = .Headline
        label.textColor = .Neutrals500
        return label
    }()
    
    private var currentDistanceStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    private var pauseButton = RunningRecordButton(frame: .zero, image: CommonAsset.pause.image)
    
    private var playButton = RunningRecordButton(frame: .zero, image: CommonAsset.play.image)
    private var stopButton = RunningRecordButton(frame: .zero, image: CommonAsset.stop.image)
    
    private var runningButtonStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
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
        addSubview(recordInfoStackView)
        recordInfoStackView.addArrangedSubview(timeLabel)
        recordInfoStackView.addArrangedSubview(CustomLineView())
        recordInfoStackView.addArrangedSubview(averagePaceLabel)
        recordInfoStackView.addArrangedSubview(CustomLineView())
        recordInfoStackView.addArrangedSubview(calorieLabel)
        
        addSubview(currentDistanceStackView)
        currentDistanceStackView.addArrangedSubview(distanceLabel)
        currentDistanceStackView.addArrangedSubview(unitLabel)
        
        addSubview(pauseButton)
        
        addSubview(runningButtonStackView)
        runningButtonStackView.addArrangedSubview(stopButton)
        runningButtonStackView.addArrangedSubview(playButton)
    }
    
    private func setupConstraints() {
        recordInfoStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(56)
            make.left.right.equalToSuperview()
        }
        
        currentDistanceStackView.snp.makeConstraints { make in
            make.top.equalTo(recordInfoStackView.snp.bottom).offset(100)
            make.left.right.equalToSuperview()
        }
        
        pauseButton.snp.makeConstraints { make in
            make.top.equalTo(currentDistanceStackView.snp.bottom).offset(130)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        runningButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(currentDistanceStackView.snp.bottom).offset(130)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
    }
    
    //MARK: - Helpers
    
    func toggleRunningState(isRunning: Bool) {
        pauseButton.isHidden = isRunning
        runningButtonStackView.isHidden = !isRunning
    }
}
