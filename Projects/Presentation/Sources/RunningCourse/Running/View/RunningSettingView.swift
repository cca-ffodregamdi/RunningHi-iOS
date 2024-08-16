//
//  RunningSettingView.swift
//  Presentation
//
//  Created by najin on 8/5/24.
//

import UIKit
import SnapKit
import Domain
import Common

class RunningSettingView: UIView {
    
    //MARK: - Configure
    
    lazy var distanceButton = RunningSettingButton(title: "거리", isActive: true)
    lazy var timeButton = RunningSettingButton(title: "시간", isActive: false)
    
    let distancePickerView = UIPickerView()
    private var distanceUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "km"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        return label
    }()
    
    let timePickerView = UIPickerView()
    private var hourUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "시간"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private var minuteUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "분"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    var playButton = RunningRecordButton(frame: .zero, image: CommonAsset.playSBlue.image.resized(to: .init(width: 88, height: 88)))
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        congifureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        congifureUI()
    }
    
    //MARK: - Configure
    
    private func congifureUI() {
        backgroundColor = .BaseWhite
        
        addSubview(distanceButton)
        addSubview(timeButton)
        
        addSubview(distancePickerView)
        addSubview(distanceUnitLabel)
        
        addSubview(timePickerView)
        addSubview(hourUnitLabel)
        addSubview(minuteUnitLabel)
        
        addSubview(playButton)
        
        distanceButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(26)
            make.top.equalToSuperview().inset(51)
        }
        
        timeButton.snp.makeConstraints { make in
            make.left.equalTo(distanceButton.snp.right).offset(9)
            make.top.equalToSuperview().inset(51)
        }
        
        distancePickerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-45)
            make.centerY.equalToSuperview()
            make.width.equalTo(300)
        }
        
        distanceUnitLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(45)
            make.centerY.equalToSuperview()
        }
        
        timePickerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(300)
        }
        
        hourUnitLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
        }
        
        minuteUnitLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(110)
            make.centerY.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(51)
        }
    }
    
    //MARK: - Helpers
    
    func setSettingType(_ type: RunningSettingType) {
        distanceButton.setActive(type == .distance)
        distancePickerView.isHidden = (type != .distance)
        distanceUnitLabel.isHidden = (type != .distance)
        
        timeButton.setActive(type == .time)
        timePickerView.isHidden = (type != .time)
        hourUnitLabel.isHidden = (type != .time)
        minuteUnitLabel.isHidden = (type != .time)
    }
}
