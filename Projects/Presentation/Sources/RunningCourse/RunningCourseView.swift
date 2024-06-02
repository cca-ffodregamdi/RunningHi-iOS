//
//  RunningCourseView.swift
//  Presentation
//
//  Created by 오영석 on 5/8/24.
//

import UIKit
import MapKit
import SnapKit

class RunningCourseView: UIView {
    
    lazy var mapView: MapView = {
        let mapView = MapView()
        
        return mapView
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("종료", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00km"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
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
    
    private func setupViews() {
        addSubview(mapView)
        addSubview(startButton)
        addSubview(stopButton)
        addSubview(timeLabel)
        addSubview(distanceLabel)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(padding)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(padding)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-padding)
            make.bottom.equalTo(self.snp.centerY)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(padding * 2)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(padding)
        }
        
        stopButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(padding * 2)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-padding)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(startButton.snp.bottom).offset(padding * 2)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(padding)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(stopButton.snp.bottom).offset(padding * 2)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-padding)
        }
    }
}

extension RunningCourseView {
    func updateRunningState(isRunning: Bool) {
        startButton.isEnabled = !isRunning
        stopButton.isEnabled = isRunning
    }
    
    func updateTimerLabel(timeString: String) {
        timeLabel.text = timeString
    }
    
    func updateDistanceLabel(distance: Double) {
        distanceLabel.text = String(format: "%.2fkm", distance / 1000)
    }
}
