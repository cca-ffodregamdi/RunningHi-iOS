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
    
    private var timeLabel = RunningInfoCell(title: "시간", initData: "00:00:00")
    private var averagePaceLabel = RunningInfoCell(title: "평균 페이스", initData: Int.convertMeanPaceToString(meanPace: 0))
    private var calorieLabel = RunningInfoCell(title: "소모 칼로리", initData: "0 kcal")
    
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
    
    var pauseButton = RunningRecordButton(frame: .zero, image: CommonAsset.pauseLBlue.image.resized(to: .init(width: 88, height: 88)))
    var playButton = RunningRecordButton(frame: .zero, image: CommonAsset.playSBlue.image.resized(to: .init(width: 72, height: 72)))
    var stopButton = RunningRecordButton(frame: .zero, image: CommonAsset.stopSBlack.image.resized(to: .init(width: 72, height: 72)))
    
    let stopButtonlongPressGesture = UILongPressGestureRecognizer()
    
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
        
        stopButton.addGestureRecognizer(stopButtonlongPressGesture)
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
//            make.height.width.equalTo(100)
        }
        
        runningButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(currentDistanceStackView.snp.bottom).offset(130)
            make.centerX.equalToSuperview()
//            make.height.width.equalTo(100)
        }
    }
    
    //MARK: - Helpers
    
    func setRunningData(time: Int = 0, calorie: Int = 0) {
        timeLabel.setData(data: TimeUtil.convertSecToTimeFormat(sec: time))
        calorieLabel.setData(data: "\(calorie) kcal")
    }
    
    func setRunningData(distance: Double = 0.0, pace: Int = 0) {
        distanceLabel.text = String(format: "%.2f", distance)
        averagePaceLabel.setData(data: "\(Int.convertMeanPaceToString(meanPace: pace))")
    }
    
    func toggleRunningState(isRunning: Bool) {
        pauseButton.isHidden = !isRunning
        runningButtonStackView.isHidden = isRunning
    }
}
